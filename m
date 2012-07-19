Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2GSJlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:41:42 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45062 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887Ab2GSJll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:41:41 -0400
Message-ID: <1342690897.3059.24.camel@dabdike.int.hansenpartnership.com>
Subject: Re: Fwd: UEFI Secure boot using qemu-kvm
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: joeyli <jlee@suse.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Date: Thu, 19 Jul 2012 10:41:37 +0100
In-Reply-To: <1342131474.3577.47.camel@lyra>
References: <1340877668.6196.143.camel@linux-s257.site>
	 <CAGLnvc-hLpUZaaOkeWMRtYefwL5goxuWP_99FyAzem7s_mncPg@mail.gmail.com>
	 <1340879091.6196.147.camel@linux-s257.site>
	 <1341073290.16691.14.camel@linux-s257.site> <1342131474.3577.47.camel@lyra>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 16:17 -0600, Khalid Aziz wrote:
> I Tried to follow the steps Joey had written down (Thanks for doing
> that!) on Ubuntu 12.04 and ran into some problems. Here is what I had to
> do differently to get it to work:
> 
> - Install libssl-dev
> 
> - Use "sudo alien --to-deb sbsigntools-0.3-1.1.x86_64.rpm" to convert
> sbsigntools package and "dpkg -i" the resulting deb package
> 
> - Before building efitools, edit Make.rules and replace "/usr/lib64"
> with "/usr/lib"
> 
> - Run "make PK.h DB.h KEK.h" followed by "make". Make will fail to build
> Loader.so with error being __stack_chk_fail is undefined. Ubuntu's
> version of gcc enables stack check by default and adding
> -fno-stack-protector to CFLAGS did not help. I haven't figured this one
> out yet but Helloworld.efi builds correctly.

Actually, I just ran into this too.  Apparently libefi.a needs to be
build with -fno-stack-protector ... at least that's where the problem is
coming from in my environment.  I don't have an ubuntu system to check,
but to verify this is your issue, try:

nm -D /usr/lib/libefi.a | grep __stack_chk_fail

(or whatever your path is to libefi.a) ... probably you should also
check libgnuefi.a, although this one is clear in my setup.

James







