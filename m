Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1H3Slj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:41:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42690 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756023Ab1H3Slf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:41:35 -0400
Date: Tue, 30 Aug 2011 19:41:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: x86@kernel.org, Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [v2 2/4] platform: (TS-5500) add GPIO support
Message-ID: <20110830184132.GR2061@opensource.wolfsonmicro.com>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1314402027-11293-3-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20110829221132.GB26846@sirena.org.uk>
 <20110830143928.4696ec2a@v0nbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110830143928.4696ec2a@v0nbox>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 02:39:28PM -0400, Vivien Didelot wrote:
> On Mon, 29 Aug 2011 23:11:33 +0100,
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> > On Fri, Aug 26, 2011 at 07:40:25PM -0400, Vivien Didelot wrote:
> > > +	bitno = line_to_bit_map[offset];

> > > +	mutex_lock(&drvdata->gpio_lock);
> > > +	byte = inb(ioaddr);
> > > +	mutex_unlock(&drvdata->gpio_lock);

> > Do you really need the lock to do a read?

> Is there any chance for this function to be preempted before reading the
> register, allowing a call to ts5500_gpio_direction_output to occur
> before ts5500_gpio_get is completed?

Yes, but if that happens the mutex isn't going to help at all as you can
also be prempted before taking the mutex or after dropping it (or before
or after the function call itself...).
