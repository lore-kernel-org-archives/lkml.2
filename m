Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab1FNNKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 09:10:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36991 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1FNNKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 09:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=FFXPDBfQxtSDL7I7NSNH33rAEyghlrvlUancTuMnTdqPVdibD4TMZ414N1619YDt4H
         vtuyR2igDFMLicbyuqKoaZpVKIql+MkpuhhY68IfAv+gzPfuUP7jwXcCFszX7wgphing
         jw+KEYucbOCVL4nn6uMPfUi/4kUsa+rVHHs08=
MIME-Version: 1.0
In-Reply-To: <BANLkTimR3RbcaG6DfVHH1SUz0upa4tEXCg@mail.gmail.com>
References: <BANLkTinCfV4owNBhJ+F-yfF3V+wg1o=PLA@mail.gmail.com>
 <BANLkTim_bHKdZnykedzW4re6GMCg+1Ed2g@mail.gmail.com> <BANLkTimR3RbcaG6DfVHH1SUz0upa4tEXCg@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 14 Jun 2011 15:08:41 +0200
Message-ID: <BANLkTi=XrH2sBkk-3fbrY4Worj3SW1W1AQ@mail.gmail.com>
Subject: Re: Linux 3.0-rc3
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 2:55 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Tue, Jun 14, 2011 at 3:15 PM, Denys Vlasenko
> <vda.linux@googlemail.com> wrote:
>> I've got a patch for my project to fix parsing of kernel version which
>> has only two numbers. Basically,
>
> Why does your project care about kernel version?

It's depmod. It was assuming that if argument starts with three digits,
it's a kernel version:

        /* If a version is provided, then that kernel version's module directory
         * is used, rather than the current kernel version (as returned by
         * "uname -r").  */
        if (*argv && sscanf(*argv, "%u.%u.%u", &tmp, &tmp, &tmp) == 3) {
                version = *argv++;
        } else {
                uname(&uts);
                version = uts.release;
        }


-- 
vda
