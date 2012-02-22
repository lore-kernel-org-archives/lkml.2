Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab2BVWYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 17:24:35 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36666 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab2BVWYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 17:24:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rmallon@gmail.com designates 10.68.218.5 as permitted sender) smtp.mail=rmallon@gmail.com; dkim=pass header.i=rmallon@gmail.com
Message-ID: <4F456B1E.1080700@gmail.com>
Date: Thu, 23 Feb 2012 09:24:30 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: [PATCH v2 05/19] ARM: at91/ST: remove not needed casts
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com> <7fc3c7e0093a675e205fe1763de7dfccdda8e692.1329903206.git.nicolas.ferre@atmel.com>
In-Reply-To: <7fc3c7e0093a675e205fe1763de7dfccdda8e692.1329903206.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/02/12 20:39, Nicolas Ferre wrote:

> Remove the unnecessary (void) cast on at91_st_read()
> return value.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>


Thanks Nicolas.

Acked-by: Ryan Mallon <rmallon@gmail.com>

> ---
>  arch/arm/mach-at91/at91rm9200_time.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
> index 0c1980c..dd7f782 100644
> --- a/arch/arm/mach-at91/at91rm9200_time.c
> +++ b/arch/arm/mach-at91/at91rm9200_time.c
> @@ -111,7 +111,7 @@ clkevt32k_mode(enum clock_event_mode mode, struct clock_event_device *dev)
>  {
>  	/* Disable and flush pending timer interrupts */
>  	at91_st_write(AT91_ST_IDR, AT91_ST_PITS | AT91_ST_ALMS);
> -	(void) at91_st_read(AT91_ST_SR);
> +	at91_st_read(AT91_ST_SR);
>  
>  	last_crtr = read_CRTR();
>  	switch (mode) {
> @@ -157,7 +157,7 @@ clkevt32k_next_event(unsigned long delta, struct clock_event_device *dev)
>  
>  	/* Cancel any pending alarm; flush any pending IRQ */
>  	at91_st_write(AT91_ST_RTAR, alm);
> -	(void) at91_st_read(AT91_ST_SR);
> +	at91_st_read(AT91_ST_SR);
>  
>  	/* Schedule alarm by writing RTAR. */
>  	alm += delta;
> @@ -192,7 +192,7 @@ void __init at91rm9200_timer_init(void)
>  	/* Disable all timer interrupts, and clear any pending ones */
>  	at91_st_write(AT91_ST_IDR,
>  		AT91_ST_PITS | AT91_ST_WDOVF | AT91_ST_RTTINC | AT91_ST_ALMS);
> -	(void) at91_st_read(AT91_ST_SR);
> +	at91_st_read(AT91_ST_SR);
>  
>  	/* Make IRQs happen for the system timer */
>  	setup_irq(AT91_ID_SYS, &at91rm9200_timer_irq);


