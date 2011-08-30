Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1H3Sjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:39:51 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:50575 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab1H3Sjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:39:33 -0400
Date: Tue, 30 Aug 2011 14:39:28 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: x86@kernel.org, Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [v2 2/4] platform: (TS-5500) add GPIO support
Message-ID: <20110830143928.4696ec2a@v0nbox>
In-Reply-To: <20110829221132.GB26846@sirena.org.uk>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1314402027-11293-3-git-send-email-vivien.didelot@savoirfairelinux.com>
	<20110829221132.GB26846@sirena.org.uk>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011 23:11:33 +0100,
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Aug 26, 2011 at 07:40:25PM -0400, Vivien Didelot wrote:
> > +	bitno = line_to_bit_map[offset];
> > +
> > +	mutex_lock(&drvdata->gpio_lock);
> > +	byte = inb(ioaddr);
> > +	mutex_unlock(&drvdata->gpio_lock);
> 
> Do you really need the lock to do a read?

Is there any chance for this function to be preempted before reading the
register, allowing a call to ts5500_gpio_direction_output to occur
before ts5500_gpio_get is completed?

	Vivien.
