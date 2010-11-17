Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934490Ab0KQHMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 02:12:15 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36774 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933879Ab0KQHMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 02:12:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B4WEKBkESKSjTzVe9WlDZpallTngF26ZGgGkXEcqCRz41tmJoeCBU7X1C5yRUyZEev
         DBDxvQ61U+9G9ZnQj+HC2AcRPpIVox14NF0uHklpsTDIG/fsSHP6P6wxnz/btsO716+0
         qnBnHjSc1+vNdXbXLlT8hrptntRNbCGOWQ/1E=
Date: Tue, 16 Nov 2010 23:12:07 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101117071207.GB7046@core.coreip.homeip.net>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at>
 <20101110035833.GB3029@kamineko.org>
 <20101111235000.GA6651@gamma.logic.tuwien.ac.at>
 <20101112034423.GA7407@srcf.ucam.org>
 <20101112035027.GD26742@gamma.logic.tuwien.ac.at>
 <20101112035732.GB7574@srcf.ucam.org>
 <20101112042243.GE2852@kamineko.org>
 <20101117063006.GF29129@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117063006.GF29129@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:30:06PM +0900, Norbert Preining wrote:
> Hi Mattia, hi Dmitry,
> 
> On Fr, 12 Nov 2010, Mattia Dongili wrote:
> > backlight (actually Fn+F[56]) is one of those keys the needs remapping
> > these days, i.e. if xev doesn't get any event in X then you may need
> > something like:
> 
> Ok, I have now done the fllowing:
> - recompiled a input-kbd binary with a relaxed version check
> 	-	if (EV_VERSION != version) {
> 	+	if (EV_VERSION > version) {
>   in input.c, line 104 of input-utils.
> 
> - created a vaio-kbd from the output of input-kbd and changed the
>   keys that hat keycode 470 and 471 (those shown in evtest 8)
>   to key_brightness:
> 
> $ diff -u <(./input-kbd 8) vaio-kbd
> --- /dev/fd/63	2010-11-17 15:24:32.023696588 +0900
> +++ vaio-kbd	2010-11-17 15:24:02.000000000 +0900
> @@ -13,8 +13,8 @@
>  0x0006 = 467  # KEY_FN_F2
>  0x0007 = 468  # KEY_FN_F3
>  0x0008 = 469  # KEY_FN_F4
> -0x0009 = 470  # KEY_FN_F5
> -0x000a = 471  # KEY_FN_F6
> +0x0009 = 224  # KEY_BRIGHTNESSDOWN
> +0x000a = 225  # KEY_BRIGHTNESSUP
>  0x000b = 472  # KEY_FN_F7
>  0x000c = 473  # KEY_FN_F8
>  0x000d = 474  # KEY_FN_F9
> $
> 
> remember:
> evtest /dev/input/event8 reports code 470 and code 471 for the respective
> Fn-F5 and Fn-F6 combinations.
> 
> > output to a file, edit it to change the keys you need remapped and run
> > `input-kbd -f <file> <devNo>`.
> 
> Then I run
> 	$ ./input-kbd -f vaio-kbd 8
> 	/dev/input/event8
> 	map: 44 keys, size: 59/64
> 	parse error: /dev/input/event8

"Parse error" suggests issue with teh keymap file.

> 	$
> with the effect that still brigthness is not working.
> 
> If someone can explain what is wrong here and how to get this fixed
> that would be nice, because up to now on the sony-vaio mailing list
> I heard many complains about disappearing brightness, I hope we can
> fix that.
> 

I did compile input-utils from sid and after fixing up the version issue
I can change mappings on my AT keyboard. Could you try doing the same -
maybe the issue is with the sony-laptop driver (rather its irectaion
with the large scancode support) as well as with input-kbd utility.

Thanks.

-- 
Dmitry
