Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab1DFLzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:55:10 -0400
Received: from mx2.parallels.com ([64.131.90.16]:54953 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827Ab1DFLzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:55:08 -0400
Message-ID: <4D9C5494.1090607@parallels.com>
Date: Wed, 6 Apr 2011 06:55:00 -0500
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Tejun Heo <tj@kernel.org>, Pete Clements <clem@clem.clem-digital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
References: <201103291551.p2TFpDqZ001692@clem.clem-digital.net> <4D92C874.7040104@parallels.com> <4D931634.5030807@fusionio.com> <4D933584.5050005@parallels.com> <4D94432D.5080601@fusionio.com> <4D944544.9040705@parallels.com> <4D945247.4080404@fusionio.com> <4D945976.8000401@fusionio.com> <20110331121100.GD3385@htj.dyndns.org> <4D9474AA.4070402@fusionio.com>
In-Reply-To: <4D9474AA.4070402@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.54.86.73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 07:33 AM, Jens Axboe wrote:
> On 2011-03-31 14:11, Tejun Heo wrote:
>> Hello,
>>
>> On Thu, Mar 31, 2011 at 12:37:42PM +0200, Jens Axboe wrote:
>>> It seems to hard hang, looks very odd:
>> I think more likely failure mode is something is looping in block path
>> expecting someone else to do something but as it is busy looping and
>> preemption isn't enabled the someone else can't proceed.  We had a
>> similar problem in md lately.
>>
>>  http://thread.gmane.org/gmane.linux.raid/33020
> 
> I think this sound exactly right, and also explains why SMP works. And
> yes CONFIG_PREEMPT_VOLUNTARY=y is set.
> 
>> If this is the case, a good way to debug would be triggering sysrq-l
>> multiple times while the machine is hung and see where the CPU is busy
>> looping.
> 
> Doesn't respond to sysrq. I'll poke around.

Pulled and retested, still hanging for me right after announcing ext3.
Just FYI.

Rob
