Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab1ACQeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:34:50 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42772 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab1ACQet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:34:49 -0500
Message-ID: <4D21FAA3.8030505@ridgerun.com>
Date: Mon, 03 Jan 2011 09:34:43 -0700
From: Todd Fischer <todd.fischer@ridgerun.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 10/32] input/tps6507x-ts: use system_wq instead of dedicated
 workqueue
References: <1294062595-30097-1-git-send-email-tj@kernel.org> <1294062595-30097-11-git-send-email-tj@kernel.org> <20110103143926.GX1886@bicker>
In-Reply-To: <20110103143926.GX1886@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Polling is only necessary because I was given brain dead hardware.  I 
was expecting updated hardware with the interrupt signal connected 
properly, but haven't received it yet.

Any reasonable hardware will not need tps6507x-ts polling.  I was under 
the impression I could only push patches that I have tested.  Since I 
haven't tested an interrupt version of the driver, I didn't include a 
patch that removes the polling and replaces it with interrupts.

I have another customer planning on using the TPS6507x chip for touch 
screen.  I expect their hardware in around 3 weeks.

Todd

On 01/03/2011 07:39 AM, Dan Carpenter wrote:
> On Mon, Jan 03, 2011 at 02:49:33PM +0100, Tejun Heo wrote:
>> With cmwq, there's no reason to use a separate workqueue.  Drop
>> tps6507x_ts->wq and use system_wq instead.
>>
>> Signed-off-by: Tejun Heo<tj@kernel.org>
>> Cc: Dmitry Torokhov<dmitry.torokhov@gmail.com>
>> Cc: linux-input@vger.kernel.org
>> Cc: Dan Carpenter<error27@gmail.com>
>> Cc: Todd Fischer<todd.fischer@ridgerun.com>
>> ---
>> Only compile tested.  Please feel free to take it into the subsystem
>> tree or simply ack - I'll route it through the wq tree.
>>
> This is that driver that polls every 30 ms.  :/  Todd, is there no way
> to avoid this?  What was the status on that?
>
> regards,
> dan carpenter
>
>

