Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab1ITO4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:56:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34474 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1ITO4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:56:33 -0400
MIME-Version: 1.0
In-Reply-To: <4E7898E1.5030000@sysgo.com>
References: <4E7898E1.5030000@sysgo.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 20 Sep 2011 07:56:12 -0700
X-Google-Sender-Auth: GMMoQKQYsr5v7g3XL_vtmQ8c-ME
Message-ID: <CA+55aFyFqoYC0mOFHpb7jXWn3bvK855evhw=bHDn5gjJaSc5Ew@mail.gmail.com>
Subject: Re: [PATCH] init: Carefuly handle loglevel option passed to kernel cmdline.
To: Alexander Sverdlin <asv@sysgo.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 6:45 AM, Alexander Sverdlin <asv@sysgo.com> wrote:
>
> Carefuly handle loglevel option passed to kernel cmdline.

Ugh. I dislike how you misuse the error numbers - it *happens* to
work, but we return negative error numbers, not positive ones in the
kernel.

Also, doing an if/else when one arm does a return just looks overly complicated.

Does this (whitespace-damaged) patch work for you?

                 Linus

---
 init/main.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index 9c51ee7adf3d..5827722ec491 100644
--- a/init/main.c
+++ b/init/main.c
@@ -209,7 +209,11 @@ early_param("quiet", quiet_kernel);

 static int __init loglevel(char *str)
 {
-       get_option(&str, &console_loglevel);
+       int loglevel;
+
+       if (!get_option(&str, &loglevel))
+               return -EINVAL;
+       console_loglevel = loglevel;
        return 0;
 }
