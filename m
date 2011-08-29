Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1H2WRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 18:17:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39451 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab1H2WRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 18:17:07 -0400
Date: Mon, 29 Aug 2011 23:16:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: x86@kernel.org, Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [v2 3/4] platform: (TS-5500) add LED support
Message-ID: <20110829221654.GD26846@sirena.org.uk>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1314402027-11293-4-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314402027-11293-4-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Cookie: Every morning is a Smirnoff morning.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 07:40:26PM -0400, Vivien Didelot wrote:

> +static void ts5500_led_work(struct work_struct *work)
> +{
> +	struct ts5500_led *led = container_of(work, struct ts5500_led, work);
> +	u8 val = led->new_brightness ? led->bit : 0;
> +
> +	outb(val, led->ioaddr);
> +}

Can you not do outb() from atomic context?  The reason lots of LED
drivers update the hardware in a workqueue is that they communicate with
the hardware over buses that can't be used in atomic context like I2C or
SPI but if that's not an issue then the workqueue is not required and
the code can be simplified.
