Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031214Ab2CNXl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:41:29 -0400
Received: from nk11p00mm-asmtp004.mac.com ([17.158.161.3]:48136 "EHLO
	nk11p00mm-asmtpout004.mac.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030189Ab2CNXl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:41:28 -0400
X-Greylist: delayed 3609 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2012 19:41:28 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-14_06:2012-03-14,2012-03-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1203140247
Message-id: <4F611ED0.3030702@mac.com>
Date: Wed, 14 Mar 2012 23:42:24 +0100
From: Peter Waechtler <pwaechtler@mac.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215
 Thunderbird/10.0.2
To: "EXTERNAL Waechtler Peter (Fa. TCP, CM-AI/PJ-CF31)" 
	<external.Peter.Waechtler@de.bosch.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] how to get something like chkspace / kinfo_getvmmap?
References: <274124B9C6907D4B8CE985903EAA19E91B2C998E04@SI-MBX06.de.bosch.com>
In-reply-to: <274124B9C6907D4B8CE985903EAA19E91B2C998E04@SI-MBX06.de.bosch.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.03.2012 15:31, EXTERNAL Waechtler Peter (Fa. TCP, CM-AI/PJ-CF31) 
wrote:
> Hi,
>
> for implementing robust exception handlers that print out a backtrace in
> the signal handler, it would be nice to have a syscall to check if a
> memory access would fail.
>
> I know that one can parse /proc/self/maps (like libsigsegv does).
> libunwind employs an addrspace->access_mem() method that does an
> unprotected access because there is no (easy) way on Linux.
>
>
> How about enhancing mincore() with a few bits that tells the caller how
> the protection bits are?
> The main use case is in an embedded system to avoid that the handler
> (already running on an alternate signal stack) faults if the stack pointer
> achieved to point into the guard page - causing backtrace() to fail.
>
> mincore() on FreeBSD provides some more bits, but still the access bits
> are missing.
>
>       MINCORE_INCORE            Page is in core (resident).
>       MINCORE_REFERENCED        Page has been referenced by us.
>       MINCORE_MODIFIED          Page has been modified by us.
>       MINCORE_REFERENCED_OTHER  Page has been referenced.
>       MINCORE_MODIFIED_OTHER    Page has been modified.
>       MINCORE_SUPER             Page is part of a "super" page. (only i386&
>                                 amd64)
>
> add
>
>          MINCORE_PROT_W
>          MINCORE_PROT_R
>          MINCORE_PROT_X

Well, I guess some code will help?

This will also help in recognizing a guard page, for a clear and 
unambiguous:
"stack overflow" in multi-threaded programs.

     Peter

