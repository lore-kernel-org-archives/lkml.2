Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab0G1NNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 09:13:13 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:35416 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab0G1NNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 09:13:05 -0400
Message-ID: <4C502CC5.7070205@linux.vnet.ibm.com>
Date: Wed, 28 Jul 2010 15:12:37 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Karol Lewandowski <k.lewandowsk@samsung.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: GCOV doesn't seem to work on ARM with kernel 2.6.35-rc6
References: <4C4D6458.6040402@samsung.com> <4C4D6554.30707@samsung.com> <4C4DBE8E.70102@linux.vnet.ibm.com> <4C4E8C2C.3000903@samsung.com>
In-Reply-To: <4C4E8C2C.3000903@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.07.2010 09:35, Karol Lewandowski wrote:
> On 07/26/2010 06:57 PM, Peter Oberparleiter wrote:
>> Karol Lewandowski wrote:
>>> On 07/26/2010 12:32 PM, Karol Lewandowski wrote:
>>>> I'm trying to use code coverage measurements with mainline Linux kernel
>>>> 2.6.35-rc6 on ARM platform (specifically on Samsung's S5PC110 board).
> ...
>> I just tested gcov support for 2.6.35-rc6 on s390 and it works without
>> a problem. My assumption would be that you are using an EABI-GCC to
>> compile your kernel. Those compilers name their constructor symbols
>
> Exactly.
>
>> differently than the vanilla GCC so that the whole constructor calling
>> mechanism on which the gcov support relies, will fail. If that is
>> indeed the case, the following testing patch should solve your
>> problem:
>
> Yes, that was the case and your patch indeed solved my problem.

Excellent. I could imagine that other ARM users might also benefit from 
this patch. Before I submit it for integration though, I need to make 
sure that it also works for kernel modules. Could you enable profiling 
for a kernel module and verify that you are seeing files in 
/sys/kernel/debug/gcov belonging to that module??


Regards,
   Peter Oberparleiter

