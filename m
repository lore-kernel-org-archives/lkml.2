Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0KIQoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:44:18 -0500
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4875 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab0KIQoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:44:13 -0500
Message-ID: <4CD97A3D.1040602@xs4all.nl>
Date: Tue, 09 Nov 2010 17:43:41 +0100
From: Jim <jim876@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Thunderbird/3.1.5
MIME-Version: 1.0
To: Andreas Schwab <schwab@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
References: <4CD538CA.8010901@xs4all.nl> <87wroostw3.fsf@basil.nowhere.org>	<m2hbfsu57i.fsf@igel.home> <87k4kospnd.fsf@basil.nowhere.org>	<AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>	<877hgorrj1.fsf@basil.nowhere.org> <4CD843DC.10106@gmail.com>	<Pine.LNX.4.64.1011091352460.29956@wotan.suse.de>	<20101109134816.GB29433@basil.fritz.box> <m3lj52txaq.fsf@redhat.com>
In-Reply-To: <m3lj52txaq.fsf@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------050105010607000008060809"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050105010607000008060809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/09/2010 02:57 PM, Andreas Schwab wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
>> @@ -142,7 +142,7 @@ static int i8k_smm(struct smm_regs *regs)
>>  		"lahf\n\t"
>>  		"shrl $8,%%eax\n\t"
>>  		"andl $1,%%eax\n"
>> -		:"=a"(rc)
>> +		:"=a"(rc), "=m" (*regs)
> 
> I think this should be "+m".
> 
> Andreas.
> 

Just tested Andi's patch with Andreas' suggestion to make it +m,
i.e. like attached and can confirm it solves the issue.

Thanks guys,
   Jim Bos



--------------050105010607000008060809
Content-Type: text/plain;
 name="PATCH.i8k.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="PATCH.i8k.c"

--- i8k.c.ORIG	2010-08-02 17:20:46.000000000 +0200
+++ i8k.c	2010-11-09 17:31:29.000000000 +0100
@@ -141,7 +141,7 @@
 		"lahf\n\t"
 		"shrl $8,%%eax\n\t"
 		"andl $1,%%eax\n"
-		:"=a"(rc)
+		:"=a"(rc), "+m" (*regs)
 		:    "a"(regs)
 		:    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #else
@@ -166,7 +166,7 @@
 	    "movl %%edx,0(%%eax)\n\t"
 	    "lahf\n\t"
 	    "shrl $8,%%eax\n\t"
-	    "andl $1,%%eax\n":"=a"(rc)
+	    "andl $1,%%eax\n":"=a"(rc), "+m" (*regs)
 	    :    "a"(regs)
 	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #endif

--------------050105010607000008060809--
