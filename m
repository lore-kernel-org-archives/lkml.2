Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2HGL4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:56:14 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38652 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab2HGL4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:56:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVh_D1yTYiPoRks8-sjoNb_dr5xpRbxv+AJLseUd2Kk0Q@mail.gmail.com>
References: <50205592.1030205@gmail.com>
	<5020AA5B.4080407@zankel.net>
	<CAMuHMdVh_D1yTYiPoRks8-sjoNb_dr5xpRbxv+AJLseUd2Kk0Q@mail.gmail.com>
Date: Tue, 7 Aug 2012 15:56:11 +0400
Message-ID: <CAMo8BfLw0Rt8Z-Tn0k40szP1ZPtwGcV27aEp3MOVEBNx+C3tgA@mail.gmail.com>
Subject: Re: xtensa port maintenance
From: Max Filippov <jcmvbkbc@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, linux-next@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Marc Gauthier <marc@tensilica.com>,
        Kirill Krinkin <kirill.krinkin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 3:36 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Hi Chris,
>
> On Tue, Aug 7, 2012 at 7:40 AM, Chris Zankel <chris@zankel.net> wrote:
>> On 08/06/2012 04:38 PM, Max Filippov wrote:
>>> AFAIK xtensa linux port is currently in bad shape: it doesn't work in the
>>> mainline, it fails to build in the linux-next. The latest working kernels
>>> for
>>> xtensa are 2.6.29...31 trees hosted at the git.linux-xtensa.org.
>>
>> I wouldn't say it's in bad shape, I just built an vmlinux image from the
>> latest tree (3.6.0-rc1), but it might not be very stable. One of the major
>> issues is not really the kernel but  there's actually no way to build a
>> fairly recent version of the toolchain. I have been using a somewhat more
>> recent buildroot version than what is on xtensa-linux.org, but even that
>> version of buildroot is rather old now and needed a few patches.
>
> Are the errors
>
> | dangerous relocation: l32r: literal placed after use: .literal.unlikely
> (http://kisskb.ellerman.id.au/kisskb/buildresult/6845615/)
>
> preventing linking of vmlinux toolchain issues?

They may be considered as such (toolchain now adds *.unlikely sections which
was not the case previously), or may not, depending on what one would expect
from the toolchain. I have a fix for that issue:
https://github.com/jcmvbkbc/linux-xtensa/commit/edd7c14132388d5c09c57cf12c76c6631a1e0277

-- 
Thanks.
-- Max
