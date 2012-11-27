Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2K0P5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:57:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41488 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab2K0P5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:57:18 -0500
Message-ID: <50B4E2CA.6060508@oracle.com>
Date: Tue, 27 Nov 2012 09:56:58 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
        Valdis.Kletnieks@vt.edu, David Rientjes <rientjes@google.com>,
        Arend van Spriel <arend@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: Re: [Jfs-discussion] Out of memory on 3.5 kernels
References: <505B1FA0.6030100@broadcom.com> <20120921194931.GA732@schottelius.org> <alpine.DEB.2.00.1209241538310.6356@chino.kir.corp.google.com> <20120926060653.GD16575@schottelius.org> <20120926085708.GA7839@schottelius.org> <20120927055208.GA25252@schottelius.org> <20121003212311.GA14018@schottelius.org> <22962.1349452084@turing-police.cc.vt.edu> <20121005175139.GC831@schottelius.org> <20121030103535.GA10526@schottelius.org> <50AD5791.5010702@oracle.com>
In-Reply-To: <50AD5791.5010702@oracle.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 04:37 PM, Dave Kleikamp wrote:
> On 10/30/2012 05:35 AM, Nico Schottelius wrote:
>> Good morning,
>>
>> update: this problem still exists on 3.6.2-1-ARCH and it got worse:
>>
>> I reformatted the external disk to use xfs, but as the my
>> root filesystem is still jfs, it still appears:
>>
>>  Active / Total Objects (% used)    : 642732 / 692268 (92.8%)
>>  Active / Total Slabs (% used)      : 24801 / 24801 (100.0%)
>>  Active / Total Caches (% used)     : 79 / 111 (71.2%)
>>  Active / Total Size (% used)       : 603522.30K / 622612.05K (96.9%)
>>  Minimum / Average / Maximum Object : 0.01K / 0.90K / 15.25K
>>
>>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
>> 475548 467649  98%    1.21K  18722       26    599104K jfs_ip

...

>>
>> I am wondering if anyone is feeling responsible for this bug or if the mid-term
>> solution is to move away from jfs?
> 
> Sorry, I haven't taken too close a look at this, but I did notice
> another conversation that may be related:
> 
> https://lkml.org/lkml/2012/11/17/26
> 
> The commit in question first showed up in 3.5-rc1, which coincides with
> your problem.

I believe this commit will fix the problem:
http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4eff96d

It is targeted for the stable kernels.
