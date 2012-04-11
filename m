Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab2DKKFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:05:34 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:63577 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718Ab2DKKFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:05:33 -0400
Message-ID: <1334138713.10826.134.camel@ted>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
From: Richard Purdie <richard.purdie@linuxfoundation.org>
To: shuahkhan@gmail.com
Cc: akpm@linux-foundation.org, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 11 Apr 2012 11:05:13 +0100
In-Reply-To: <1334071916.2287.12.camel@lorien2>
References: <1333310039.2879.4.camel@lorien2> <1334064283.10826.6.camel@ted>
	 <1334071916.2287.12.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-10 at 09:31 -0600, Shuah Khan wrote:
> On Tue, 2012-04-10 at 14:24 +0100, Richard Purdie wrote:
> > Having looked at the code and read through the thread and Andrew's patch
> > review, I'm left wondering why you didn't add a new trigger for this
> > functionality?
> 
> By new trigger do you mean, adding another interface to struct
> led_trigger. My first patch to solve this use-case indeed did that. I
> still happen to have a copy of that patch. It would require more changes
> to the infrastructure than this approach, however it is more explicit
> and clear.
> 
> static struct led_trigger gpio_led_trigger = {
>        .name           = "gpio",
> +       .activate_once  = NULL,
>        .activate       = gpio_trig_activate,
>        .deactivate     = gpio_trig_deactivate,
> };

No, I did not mean adding another interface. Why can't we have a trigger
which just triggers once and then stops? It would be similar to the
timer trigger but with a different name and way of operating.

> > Dimity raises some valid questions about the force-feedback framework in
> > the input system too. We need to make a decision about where phone
> > vibration framework belongs and then stick to that. You can argue this
> > to either subsystem, neither "led" or "input" is a obvious description
> > of phone vibration at a first glance!
> 
> force-feedback framework is another alternative. Making a decision is
> great, what are the next steps to get closer to making a call? 

I'd first like to understand why this couldn't be a separate trigger,
then we can understand the alternatives we're comparing.

Cheers,

Richard

