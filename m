Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab1H3Soa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:44:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51309 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab1H3So1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:44:27 -0400
Message-ID: <4E5D2F55.2000608@zytor.com>
Date: Tue, 30 Aug 2011 11:43:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>, x86@kernel.org,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 2/4] platform: (TS-5500) add GPIO support
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1314402027-11293-3-git-send-email-vivien.didelot@savoirfairelinux.com> <20110829221132.GB26846@sirena.org.uk> <20110830143928.4696ec2a@v0nbox>
In-Reply-To: <20110830143928.4696ec2a@v0nbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 11:39 AM, Vivien Didelot wrote:
> On Mon, 29 Aug 2011 23:11:33 +0100,
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
>> On Fri, Aug 26, 2011 at 07:40:25PM -0400, Vivien Didelot wrote:
>>> +	bitno = line_to_bit_map[offset];
>>> +
>>> +	mutex_lock(&drvdata->gpio_lock);
>>> +	byte = inb(ioaddr);
>>> +	mutex_unlock(&drvdata->gpio_lock);
>>
>> Do you really need the lock to do a read?
> 
> Is there any chance for this function to be preempted before reading the
> register, allowing a call to ts5500_gpio_direction_output to occur
> before ts5500_gpio_get is completed?
> 

Wrapping an atomic operation in a mutex makes no sense no matter how you
slice it...
	
	-hpa

