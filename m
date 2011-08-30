Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1H3VOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 17:14:31 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:55535 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab1H3VO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 17:14:28 -0400
Date: Tue, 30 Aug 2011 17:14:24 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, x86@kernel.org,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 3/4] platform: (TS-5500) add LED support
Message-ID: <20110830171424.71465472@v0nbox>
In-Reply-To: <4E5C7731.3080309@zytor.com>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1314402027-11293-4-git-send-email-vivien.didelot@savoirfairelinux.com>
	<20110829221654.GD26846@sirena.org.uk>
	<4E5C7731.3080309@zytor.com>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011 22:37:53 -0700,
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 08/29/2011 03:16 PM, Mark Brown wrote:
> > On Fri, Aug 26, 2011 at 07:40:26PM -0400, Vivien Didelot wrote:
> > 
> >> +static void ts5500_led_work(struct work_struct *work)
> >> +{
> >> +	struct ts5500_led *led = container_of(work, struct
> >> ts5500_led, work);
> >> +	u8 val = led->new_brightness ? led->bit : 0;
> >> +
> >> +	outb(val, led->ioaddr);
> >> +}
> > 
> > Can you not do outb() from atomic context?  The reason lots of LED
> > drivers update the hardware in a workqueue is that they communicate
> > with the hardware over buses that can't be used in atomic context
> > like I2C or SPI but if that's not an issue then the workqueue is
> > not required and the code can be simplified.
> 
> outb() can definitely be executed from atomic context.
> 
> 	-hpa

Good to know, thanks. I removed the work_struct and instead lock a mutex
before setting led->new_brightness and calling outb().

	Vivien.
