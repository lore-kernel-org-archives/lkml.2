Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab1FKMel (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 08:34:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35367 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab1FKMej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 08:34:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=JU2WJ0FTMUVaf5oH5mz6ZpaU3/f0U+shklvTYpX+J8skeW5l8hHH3fpsd5rc74HfYf
         O9gfXrEq93mSvFQUl+8zRRljzykETn63AU14c8Y6l5pqub07PvXQ4ALr2mpqG3WRqKY9
         wzhs6PVmZpLTx1iTZYjPF7Fd2mV9zPmDcYNkY=
MIME-Version: 1.0
In-Reply-To: <BANLkTimz90oWNDYYNnpX5aDhJ192LhDkXA@mail.gmail.com>
References: <BANLkTimUSvQi9CPgO+cCUrEdQq-+ohbzFg@mail.gmail.com> <BANLkTimz90oWNDYYNnpX5aDhJ192LhDkXA@mail.gmail.com>
From: Jonathan Elchison <JElchison@Gmail.com>
Date: Sat, 11 Jun 2011 08:34:18 -0400
X-Google-Sender-Auth: wc_pag64p4NFQRTYLqVfnQeiXfI
Message-ID: <BANLkTikk2v8m1wNYoTW6anRhJgy8AS9DfA@mail.gmail.com>
Subject: Re: [PATCH] m68k: Patch for broken lsl64() "old code" with incorrect shift
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org, David Huggins-Daines <dhd@debian.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 8:01 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> I think it's better to just remove all #ifdefed out parts in the code.

I'm good either way, as long as the broken "old code" is no longer present.

> The patch is reversed?

My apologies, you're correct.  In case anyone is interested in the
correct patch:

Signed-off-by: Jonathan Elchison <jelchison@gmail.com>

-----------------------------------------------------------------
diff -up linux-2.6_orig/arch/m68k/math-emu/multi_arith.h
linux-2.6/arch/m68k/math-emu/multi_arith.h
--- linux-2.6_orig/arch/m68k/math-emu/multi_arith.h	2011-06-10
22:47:43.407285452 -0400
+++ linux-2.6/arch/m68k/math-emu/multi_arith.h	2011-06-10
22:50:32.538711320 -0400
@@ -236,7 +236,7 @@ static inline void lsl64(int count, unsi
 {
 	if (count < 32) {
 		HI_WORD(*dest) = (HI_WORD(*dest) << count)
-		    | (LO_WORD(*dest) >> count);
+		    | (LO_WORD(*dest) >> (32 - count));
 		LO_WORD(*dest) <<= count;
 		return;
 	}
-----------------------------------------------------------------

Please personally CC me on responses to this post.

v/r,

--
Jonathan Elchison
jelchison@gmail.com
