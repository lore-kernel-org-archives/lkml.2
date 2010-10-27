Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338Ab0J0Ng1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:36:27 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55015 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252Ab0J0NgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:36:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tWJwatbL+u860/ir9INwgOFVn2MehWEiQCG5S2yuyaAoL2SePJMW+0mKHXAIwlPbpD
         NNz5s22qBzPdoKnrBZZ35v1KNPJQ1mRs3nOwD6Z36UPqqlFt8ycKGXAwz8PTcQz5rutz
         9ZqyF1qRjxm1S705S4s/oXNZBeciI80sixNX0=
Message-ID: <4CC82AD3.6090300@gmail.com>
Date: Wed, 27 Oct 2010 08:36:19 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101006 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, Dinh.Nguyen@freescale.com,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
        valentin.longchamp@epfl.ch
Subject: Re: [PATCH] ARM: imx: Add some core definitions for MX53
References: <1288119235-7036-1-git-send-email-Dinh.Nguyen@freescale.com>	<20101027082958.GA6797@angua.secretlab.ca> <20101027090921.GB8554@pengutronix.de>
In-Reply-To: <20101027090921.GB8554@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 04:09 AM, Uwe Kleine-König wrote:
> Hello,
>
> On Wed, Oct 27, 2010 at 09:29:59AM +0100, Grant Likely wrote:
>>> ---
>>>   arch/arm/plat-mxc/include/mach/iomux-mx53.h |  301 +++++++++++++++++++
>>>   arch/arm/plat-mxc/include/mach/mx53.h       |  433 +++++++++++++++++++++++++++
>>
>> Hi Dinh.
>>
>> In general, these definitions should not be added until they are
>> actually needed by driver code.
> ack.
>
>> Also, from my understanding, the mx53 is very similar to the mx51.
>> If I'm correct, then they should be sharing the same set of #defines.
> Note, I asked for a seperate header file.  See
> http://thread.gmane.org/gmane.linux.kernel/1051001/focus=1051352
>
>> What is the diff between *mx51.h and *mx53.h?
> Just from a quick look at least some base addresses are different.
> (e.g. MX51_DEBUG_BASE_ADDRESS = 0x60000000, MX53_DEBUG_BASE_ADDRESS =
> 0x40000000; SPBA0, AIPS1 and AIPS2 differ, too)

It is quite simple for these buses. Subtract 0x20000000 from MX51 
address and you have the MX53 address. MX53 has some additional 
peripherals, but otherwise the common peripherals are all at the same 
relative offsets. A 3rd MX5 derivative also has the same memory map as 
MX53 with slightly different peripheral mix.

Rob


