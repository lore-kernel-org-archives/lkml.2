Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934371Ab1CZCRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 22:17:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43043 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab1CZCRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 22:17:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=N5G+WPP4exWdnnYR6wfF1orUe+0mZADWS5q8v3yP0csCwVTMrR38/DcsFWHlCCUAKU
         oC81TUh5+bvj0T7oiWaEnWCxSKtpTP1T3iZZbXLqvJc4FIi7Vm3fv4hhfRD5pCT3h2f1
         FNNYKWIs2M/gIuHmW7YJQXwNulfpUMNsMCurk=
MIME-Version: 1.0
In-Reply-To: <20110326002159.GY3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <AANLkTinQ_M92zDZx_Jfe=rvPO0Gr4kHhXZUATvgVBywh@mail.gmail.com>
 <20110325225220.GV3130@pulham.picochip.com> <201103260002.19291.arnd@arndb.de>
 <20110326002159.GY3130@pulham.picochip.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 25 Mar 2011 22:16:48 -0400
X-Google-Sender-Auth: WQrjX9ReZH7xh0ttVeuvk2fijHE
Message-ID: <AANLkTinYd+4vtSBmBGHJwbCgFiZttSTtgQaQ0txwoUxt@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
To: Jamie Iles <jamie@jamieiles.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 20:21, Jamie Iles wrote:
> For the actual ioctl() we should assume byte addressing rather than
> words though and do the conversion in the driver so we can cope with
> devices that don't have 64-bit words and do the locking on a looping
> word-by-word basis.
>
>        struct otp_lock_req {
>                __u32   start_addr;
>                __u32   byte_count;
>        };

i would add an ABI field here too so if in the future we want to add
stuff, we can do so without adding new ioctls.  like "u16 version; u16
flags;".  then in the ioctl, if version isnt 0, we return ENOTSUP.  in
the future, we can add flags or bump the version.

> Mike, would this be OK with you if we used a different ioctl() to the
> one bfin-otp is using currently?  I notice that it's using the OTPLOCK
> ioctl() from MTD but I think it's using the argument in a different way.

i re-used OTPLOCK because it's exactly the name i wanted and it was
easier than carving out my own namespace, but the args are different.
i can see how people might find this undesirable.
-mike
