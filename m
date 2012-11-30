Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031781Ab2K3Uz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:55:58 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55428 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab2K3Uz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:55:56 -0500
Message-ID: <50B91D54.2080507@linux.vnet.ibm.com>
Date: Fri, 30 Nov 2012 12:55:48 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: 32/64-bit NUMA consolidation behavior regresion
References: <50B6A66E.8030406@linux.vnet.ibm.com> <20121130204237.GH3873@htj.dyndns.org>
In-Reply-To: <20121130204237.GH3873@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12113020-2398-0000-0000-00000E62EF5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 12:42 PM, Tejun Heo wrote:
> On Wed, Nov 28, 2012 at 04:03:58PM -0800, Dave Hansen wrote:
>> My system is just qemu booted with:
>>
>> -smp 8 -m 8192 -numa node,nodeid=0,cpus=0-3 -numa node,nodeid=1,cpus=4-7
>>
>> Watch the "PERCPU:" line early in boot, and you can see the "Embedded"
>> come and go with or without your patch:
>>
>> [    0.000000] PERCPU: Embedded 11 pages/cpu @f3000000 s30592 r0 d14464
>> vs
>> [    0.000000] PERCPU: 11 4K pages/cpu @f83fe000 s30592 r0 d14464
> ...
>> I don't have a fix handy because I'm working on the original problem,
>> but I just happened to run across this during a bisect.
> 
> Just tested 3.7-rc7 w/ qemu and it works as expected here.
> 
> Can you please boot with the following debug patch and report the boot
> message before and after?

Hi Tejun,

I just tested with 3.7-rc7 and I'm seeing the expected behavior now.
Looks like it got fixed along the way somewhere.  I was bisecting way
back in the 2.6.3x's.  Sorry of the noise.

