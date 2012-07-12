Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161618Ab2GLWR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:17:59 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:33615 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab2GLWRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:17:55 -0400
Subject: Re: Fwd: UEFI Secure boot using qemu-kvm
From: Khalid Aziz <khalid.aziz@hp.com>
To: joeyli <jlee@suse.com>
Cc: linux-kernel@vger.kernel.org, JBottomley@parallels.com,
        linux-efi@vger.kernel.org
In-Reply-To: <1341073290.16691.14.camel@linux-s257.site>
References: <1340877668.6196.143.camel@linux-s257.site>
	 <CAGLnvc-hLpUZaaOkeWMRtYefwL5goxuWP_99FyAzem7s_mncPg@mail.gmail.com>
	 <1340879091.6196.147.camel@linux-s257.site>
	 <1341073290.16691.14.camel@linux-s257.site>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Jul 2012 16:17:54 -0600
Message-ID: <1342131474.3577.47.camel@lyra>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I Tried to follow the steps Joey had written down (Thanks for doing
that!) on Ubuntu 12.04 and ran into some problems. Here is what I had to
do differently to get it to work:

- Install libssl-dev

- Use "sudo alien --to-deb sbsigntools-0.3-1.1.x86_64.rpm" to convert
sbsigntools package and "dpkg -i" the resulting deb package

- Before building efitools, edit Make.rules and replace "/usr/lib64"
with "/usr/lib"

- Run "make PK.h DB.h KEK.h" followed by "make". Make will fail to build
Loader.so with error being __stack_chk_fail is undefined. Ubuntu's
version of gcc enables stack check by default and adding
-fno-stack-protector to CFLAGS did not help. I haven't figured this one
out yet but Helloworld.efi builds correctly.

- Run "make HelloWorld-kek-signed.efi" to build signed version of hello
world.

- At this point I could fire up qemu and run the signed and unsigned
versions of hello world (HelloWorld-kek-signed.efi and HelloWorld.efi)
with secure boot disabled and enabled after importing PK and KEK as Joey
showed in his instructions.

Hope this helps someone who is trying this on Ubuntu. Now on to figuring
out how to build Loader.efi.

-- 
Khalid Aziz <khalid.aziz@hp.com>

