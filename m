Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab2GSPzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 11:55:43 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:16026 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2GSPzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 11:55:38 -0400
Subject: Re: Fwd: UEFI Secure boot using qemu-kvm
From: Khalid Aziz <khalid.aziz@hp.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: joeyli <jlee@suse.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
In-Reply-To: <1342690897.3059.24.camel@dabdike.int.hansenpartnership.com>
References: <1340877668.6196.143.camel@linux-s257.site>
	 <CAGLnvc-hLpUZaaOkeWMRtYefwL5goxuWP_99FyAzem7s_mncPg@mail.gmail.com>
	 <1340879091.6196.147.camel@linux-s257.site>
	 <1341073290.16691.14.camel@linux-s257.site> <1342131474.3577.47.camel@lyra>
	 <1342690897.3059.24.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jul 2012 09:55:36 -0600
Message-ID: <1342713336.13917.124.camel@lyra>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 10:41 +0100, James Bottomley wrote:
> Actually, I just ran into this too.  Apparently libefi.a needs to be
> build with -fno-stack-protector ... at least that's where the problem is
> coming from in my environment.  I don't have an ubuntu system to check,
> but to verify this is your issue, try:
> 
> nm -D /usr/lib/libefi.a | grep __stack_chk_fail
> 
> (or whatever your path is to libefi.a) ... probably you should also
> check libgnuefi.a, although this one is clear in my setup.

On Ubuntu, it is coming from lib/lib.a. It so happens that "make clean"
does not descend into lib/ and remove *.o and lib.a. So, I added
"-fno-stack-protector" to top level Makefile, ran "make clean" followed
by make and it didn't help because I continuesd to use the old lib.a.
Now that I have realized it, I added "(cd lib; rm -f *.o lib.a)" to the
clean target in toplevel Makefile and ran a "make clean". After this
lib/Makefile inherited -fno-stack-protector in CFLAGS from Make.rules
and everything builds correctly now. 

-- 
Khalid Aziz <khalid.aziz@hp.com>

