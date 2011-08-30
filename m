Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1H3Fic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:38:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47361 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab1H3Fib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:38:31 -0400
Message-ID: <4E5C7731.3080309@zytor.com>
Date: Mon, 29 Aug 2011 22:37:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Vivien Didelot <vivien.didelot@savoirfairelinux.com>, x86@kernel.org,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 3/4] platform: (TS-5500) add LED support
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1314402027-11293-4-git-send-email-vivien.didelot@savoirfairelinux.com> <20110829221654.GD26846@sirena.org.uk>
In-Reply-To: <20110829221654.GD26846@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2011 03:16 PM, Mark Brown wrote:
> On Fri, Aug 26, 2011 at 07:40:26PM -0400, Vivien Didelot wrote:
> 
>> +static void ts5500_led_work(struct work_struct *work)
>> +{
>> +	struct ts5500_led *led = container_of(work, struct ts5500_led, work);
>> +	u8 val = led->new_brightness ? led->bit : 0;
>> +
>> +	outb(val, led->ioaddr);
>> +}
> 
> Can you not do outb() from atomic context?  The reason lots of LED
> drivers update the hardware in a workqueue is that they communicate with
> the hardware over buses that can't be used in atomic context like I2C or
> SPI but if that's not an issue then the workqueue is not required and
> the code can be simplified.

outb() can definitely be executed from atomic context.

	-hpa
