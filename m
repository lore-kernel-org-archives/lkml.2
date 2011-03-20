Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab1CTPDm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 11:03:42 -0400
Received: from omta02-pub.suddenlink.net ([208.180.40.74]:62359 "EHLO
	omta02.suddenlink.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1CTPDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 11:03:40 -0400
From: Curt Howland <Howland@priss.com>
Organization: Acolytes of the Goddess Priss
To: linux-kernel@vger.kernel.org
Subject: Patch: Re: Compile error: arch/x86/kernel/entry_32.S:1422: Error: .size expression does not evaluate to a constant
Date: Sun, 20 Mar 2011 11:03:37 -0400
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
References: <201103171741.39876.Howland@priss.com>
In-Reply-To: <201103171741.39876.Howland@priss.com>
X-KMail-QuotePrefix: > 
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103201103.37458.Howland@priss.com>
X-Cloudmark-Analysis: v=1.1 cv=Xa+JGUFQpioGoa33UcuxxNHYUG6p9xnFTEn5lEDqSS4= c=1 sm=0 a=BeJfjmuleZIA:10 a=ZhcJH6-yNT0A:10 a=8nJEP1OIZ-IA:10 a=PL7AUedcwVm3XmYROdwA:9 a=-KjFcQPI8qEkVmTBmKUA:7 a=EOdDFZQWze8wBI4oXglbS3DQKnwA:4 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Thursday 17 March 2011, Curt Howland was heard to say:
> 2.6.38-rc6 compiled just fine, 2.6.38-rc7, -rc8 and the released
> 2.6.38 all got this error, with gcc 4.4 and after Debian Unstable
> updated to gcc 4.5:
>
> arch/x86/kernel/entry_32.S: Assembler messages:
> arch/x86/kernel/entry_32.S:1422: Error: .size expression does not
> evaluate to a constant make[3]: *** [arch/x86/kernel/entry_32.o]
> Error 1

This fixes the problem. The file does not have a maintainer listed, so 
I don't know where else to send it than to the LKML. Please correct 
me or redirect as needed.

- --- entry_32.S.original	2011-03-18 08:21:51.000000000 -0400
+++ entry_32.S	2011-03-20 10:37:00.000000000 -0400
@@ -343,7 +343,7 @@
 					# int/exception return?
 	jne work_pending
 	jmp restore_all
- -END(ret_from_exception)
+END(resume_userspace)
 
 #ifdef CONFIG_PREEMPT
 ENTRY(resume_kernel)
@@ -1413,7 +1413,7 @@
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
- -END(apf_page_fault)
+END(async_page_fault)
 #endif
 
 /*
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUBTYYXSS9Y35yItIgBAQJMRwf+MUIRl9ALi04X23ano0jd0pQCwOPHXToU
OfLQLyuJLvUkX1a5guAZhB4Id855r4e4fZnMHZpq47oxWgDy/wkXzZKo0dCYkmS0
a2Myzli4p5qNUUlROLJGvllNAzUL6+2+1w/1IpNfwSnTtfj6V0lzHWlxjYrFh3Kg
yJ5S3tuS993ORX6Obd7l/CzO6AIRKiZLqXbNUDwXLJvv+w8rfUsUY0EjZlpeWJr0
4FjliC1k1ZJc8Z4LVKzQjOUQMpAp1KU6e6JKht2xOggWRcs6CIMBH+nDg4/CG0uJ
R3bVj6Z1ydnT7vrOCrDyHhZRCSjKSeOw/+xxzeYZrBYCDP6z52VXJg==
=S8vn
-----END PGP SIGNATURE-----
