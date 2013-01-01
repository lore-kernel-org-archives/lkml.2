Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3AAId1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 03:33:27 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46707 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3AAId0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 03:33:26 -0500
MIME-Version: 1.0
In-Reply-To: <1356964034.31923.12.camel@localhost>
References: <1356778810-20879-1-git-send-email-avagin@openvz.org>
	<1356904987.9725.10.camel@localhost>
	<20121231101414.GA27119@paralelels.com>
	<1356964034.31923.12.camel@localhost>
Date: Tue, 1 Jan 2013 12:26:44 +0400
Message-ID: <CANaxB-whN+BG76cw5x794DkCA1dGAnporHE4MrMODMENeTaUXg@mail.gmail.com>
Subject: Re: [PATCH] prctl: fix validation of an address
From: Andrey Wagin <avagin@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Andrew Vagin <avagin@parallels.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> The kernel makes the decision on what is valid via security_mmap_addr().
> Assuming there are no security fears of an untrusted application
> tricking some priviledged application to set up these maps the answer is
> just calling security_mmap_addr() instead of doing if(addr <
> mmap_min_addr) return -EINVAL;
>
> I don't know if it is a good idea to allow this interface to ever go
> below mmap_min_addr, but I do know that using (or even thinking about)
> dac_mmap_min_addr is wrong and you should be looking at
> security_mmap_addr() if you look at anything...

This sounds reasonable. Thank you for the comments. I'm going to send
a second version of this patch.

>
> -Eric
>
