Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0KDJCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 05:02:40 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48280 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab0KDJCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 05:02:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M8f8oI4xdE/88D//b3AaDFexbe4f545pg1QuZFpvAsTyc+QIYXfGDeSHvhxd+MvErh
         OqO6Qauvjnzzxq2Rs6G5f8wTs59Ln4pUCfmcIhc5tvjIL/lG0/H+eHdcXvKpWMgto5i4
         WqCkdM7Ap3Xb+OVUv0sFZdFIgWZxGPcJbLcN8=
Date: Thu, 4 Nov 2010 17:07:21 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: trapDoor <trapdoor6@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Pure kernel '2.6.37-rc1-00001-ge99d11d' shown as ~-dirty after
 compilation
Message-ID: <20101104090721.GG5210@cr0.nay.redhat.com>
References: <AANLkTik=04z2thHBS3Z9n68QnTs=i8g8qTFtNT3jb8cg@mail.gmail.com>
 <20101103164840.GC4683@hack>
 <AANLkTi=1GdZVYr2z6P7PfR-VKREVzk__1ZodO2nu4dNY@mail.gmail.com>
 <AANLkTimY+xFht4qLw+gx-axhfmkqBuO+GUtkt1HuCVnM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimY+xFht4qLw+gx-axhfmkqBuO+GUtkt1HuCVnM@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 06:35:46PM +0000, trapDoor wrote:
>Obviously I do that only on freshly cloned git tree or on a kernel
>unpacked from tarball. If I just update my git tree, the firmware
>files will be already in place after previous configuration. And here
>is interesting thing: neither of these commands ..
>	make mrproper
>	make distclean
>.. will remove the firmware files I had put in place manually. After
>doing 'make mrproper && make distclean' my tree should be clean. But
>those firmwares still remain there (I always check as I need to built
>them in and hence my .config refers to them). 

They even don't know your firmwares files exist, how can
you suppose them to remove those files for you?


> And if I run 'make
>oldonfig && make kernelrelease' afterwards, it will come up with a
>'non-dirty' version string. And this seems consistent: 'make mrproper
>&& make distclean' tell me that my tree is clean despite the FW files
>so 'make kernelrelease' gives me a clean version string as well - and
>exactly the same version should be propagated after compilation (in
>vmlinuz, initrd-img, grub entry, etc.). And that how it always worked
>for me before
>

Check the output of 'git status', if it says your tree is clean,
then you should not have '-dirty'.


>It's not that I think that a kernel with (only) firmware file(s) added
>manually should be considered as clean because 'make kernelrelease'
>tells me so - actually I always thought it wasis wrong. I just want to
>have 'make kernelrelease' coming up with the same version name as I'll
>get after compilation.
>

If so, you need to disable CONFIG_LOCALVERSION_AUTO *and*
append "LOCALVERSION=" to your 'make' command.
