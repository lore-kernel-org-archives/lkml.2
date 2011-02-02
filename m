Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab1BBQ6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:58:15 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38328 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab1BBQ6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:58:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CTnBVb+u2nDFRrU8gwD482/8Yh+yneIpovRprZ4+OpR74OaWdUBKWhXuMSaGu16E2S
         vG+D0iw8n3u2qV0Bc7VosqA00ubWAFIdeB4qAL3qIKp+DOv5XAMqrJVQR8yQYrCYaKV5
         NfHsYOcBDlhSTyIDiNLMuMaXXioIkK7kp8q+o=
Date: Wed, 2 Feb 2011 08:58:00 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, kraxel@redhat.com
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110202165800.GB3178@core.coreip.homeip.net>
References: <4D3C5F73.2050408@teksavvy.com>
 <4D496AAC.1010106@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D496AAC.1010106@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 09:31:08AM -0500, Chase Douglas wrote:
> On 01/23/2011 12:03 PM, Mark Lord wrote:
> > As of the 2.6.36 kernel, the userspace commands lsinput and input-kbd
> > no longer work.  And if I grab newer/patched versions of those from the latest
> > Ubuntu 10.10, then those newer/patched versions do not work with kernels
> > *before* 2.6.36.
> 
> I planned on taking another look at this before we release Ubuntu 11.04
> at the end of April. That doesn't prevent someone else from helping out
> :), but I'll make sure the utility is working again if not.
> 

Here you go:

>From dbe48c8044987da6e64036fa3f36d7b2826994d5 Mon Sep 17 00:00:00 2001
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Mon, 24 Jan 2011 22:06:10 -0800
Subject: [PATCH 1/2] Do not require exact version of EVDEV protocol, we can work with
 other versions too.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 input.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/input.c b/input.c
index 73d5df1..08f4046 100644
--- a/input.c
+++ b/input.c
@@ -101,9 +101,11 @@ int device_open(int nr, int verbose)
 		close(fd);
 		return -1;
 	}
-	if (EV_VERSION != version) {
-		fprintf(stderr, "protocol version mismatch (expected %d, got %d)\n",
-			EV_VERSION, version);
+
+#define EVDEV_MIN_VERSION 0x10000
+	if (version < EVDEV_MIN_VERSION) {
+		fprintf(stderr, "protocol version mismatch (need at least %d, got %d)\n",
+			EVDEV_MIN_VERSION, version);
 		close(fd);
 		return -1;
 	}

-- 
Dmitry
