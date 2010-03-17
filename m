Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0CQJOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:14:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab0CQJOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:14:30 -0400
Message-ID: <4BA09D5D.5090602@redhat.com>
Date: Wed, 17 Mar 2010 02:14:05 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de-DE; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: munroesj@us.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       David Miller <davem@davemloft.net>, ralf@linux-mips.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel@teksavvy.com, torvalds@linux-foundation.org
Subject: Re: 64-syscall args on 32-bit vs syscall()
References: <20100315134449.GB1653@linux-mips.org>	 <4B9E4EB1.9010800@zytor.com>	<4B9E59B7.6060405@redhat.com>	 <20100315.120004.209998642.davem@davemloft.net>	 <4B9E8D67.8040209@zytor.com>  <1268685311.2335.38.camel@pasglop>	 <1268776570.19726.98.camel@spokane1.rchland.ibm.com>	 <1268785874.2335.137.camel@pasglop>  <4BA06E1B.2040706@redhat.com> <1268816179.2335.187.camel@pasglop>
In-Reply-To: <1268816179.2335.187.camel@pasglop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/17/2010 01:56 AM, Benjamin Herrenschmidt wrote:
>>  - You keep the existing syscall() exported by glibc for binary
>> compatibility
> 
>>  - You add a new __syscall() (or whatever you want to name it) that adds
>> a dummy argument at the beginning, and whose implementation shifts
>> everything by 2 instead of 1 argument before calling into the kernel
> 
>>  - You define in unistd.h or whatever is relevant, a macro that does:
> 
>> #define syscall(__sysno, __args..) __syscall(0, _sysno, __args)
> 
>> I believe that should cover it, at least for powerpc, possibly for other
>> archs too though as I said, I may have missed something there.

How can this possibly be the case?  This will screw people who currently
work around the ppc limitations of the existing syscall.

Just leave it alone.

- -- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAkugnV0ACgkQ2ijCOnn/RHRL4gCeIY0SLDCgLqtVvuMw+pvCzkwE
3MIAoJQRK5Mc+WtC/Wz9tPFPy4X+EALe
=lexw
-----END PGP SIGNATURE-----
