Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1H3WFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:05:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52673 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab1H3WFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:05:41 -0400
Message-ID: <4E5D5E50.2080809@zytor.com>
Date: Tue, 30 Aug 2011 15:04:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>, x86@kernel.org,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 3/4] platform: (TS-5500) add LED support
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1314402027-11293-4-git-send-email-vivien.didelot@savoirfairelinux.com> <20110829221654.GD26846@sirena.org.uk> <4E5C7731.3080309@zytor.com> <20110830171424.71465472@v0nbox> <20110830211528.GU2061@opensource.wolfsonmicro.com> <4E5D535B.3050304@zytor.com> <20110830175644.2ff5d086@v0nbox>
In-Reply-To: <20110830175644.2ff5d086@v0nbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 02:56 PM, Vivien Didelot wrote:
>>
> I wrote the led_set function like:
> 
>   static void ts5500_led_set(struct led_classdev *led_cdev,
>                              enum led_brightness value)
>   {
>           struct ts5500_led *led = container_of(led_cdev,
>                                                 struct ts5500_led,
>                                                 cdev);
>           mutex_lock(&led->lock);
>           led->new_brightness = (value == LED_OFF) ? LED_OFF : LED_FULL;
>           outb(value, led->ioaddr);
>           mutex_unlock(&led->lock);
>   }
> 
> I guess the wrong value could be read if we get preempted just before
> the outb() call, am I wrong?
> 

And what happens if we do?

P.S. Your canonicalization of the value doesn't extend to outb().

	-hpa
