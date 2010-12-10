Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0LJVTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:19:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26465 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab0LJVTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:19:14 -0500
Message-ID: <4D0298D0.20303@kernel.org>
Date: Fri, 10 Dec 2010 13:17:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        eric.dumazet@gmail.com, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org
Subject: Re: [PATCH 13/16] x86: Unify cpu/apicid <-> NUMA node mapping between
 32 and 64bit
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-14-git-send-email-tj@kernel.org> <alpine.LFD.2.00.1012092230010.2653@localhost6.localdomain6> <4D029162.1040205@kernel.org> <4D029389.1050402@kernel.org>
In-Reply-To: <4D029389.1050402@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2010 12:54 PM, Tejun Heo wrote:
> On 12/10/2010 09:45 PM, Tejun Heo wrote:
>> I can change srat_detect_node() and nearby_node() to index by cpu but
>> as I have no idea what kind of broken configurations this is supposed
>> to deal with, I'm concerned that this may lead to different outcome by
>> walking the table in a different order.  I can implement an apicid ->
>> numa node mapping function for this but this is something which is
>> inherently ugly, so maybe it's best to leave it ugly.
> 
> Oh, right, another problem.  It's possible that apicid <-> numa
> mapping exists when apicid <-> cpu doesn't.  Again, this is a corner
> case which might not matter but I have no idea what kind of brokeness
> is being worked around and it would also be difficult to test whether
> the change is okay.
> 

that could happen...when SRAT and MADT is in different order. and your are booting nr_cpus=<less....> in SRAT...

should be fixed in
https://lkml.org/lkml/2010/11/22/5

Thanks

Yinghai
