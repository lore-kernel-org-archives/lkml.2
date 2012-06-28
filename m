Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2F1LhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 07:37:15 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:3935 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2F1LhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 07:37:13 -0400
Date: Thu, 28 Jun 2012 13:36:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8 v3] i2c: i801: check INTR after every transaction
Message-ID: <20120628133650.6b7c8746@endymion.delvare>
In-Reply-To: <CAGS+omCoto4djKuZUooeD2A-szjrH4e9=YJCptR_raOdQ8g3-A@mail.gmail.com>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
	<1340805255-8041-4-git-send-email-djkurtz@chromium.org>
	<20120627180724.762f854a@endymion.delvare>
	<CAGS+omCoto4djKuZUooeD2A-szjrH4e9=YJCptR_raOdQ8g3-A@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012 15:51:34 +0800, Daniel Kurtz wrote:
> On Thu, Jun 28, 2012 at 12:07 AM, Jean Delvare <khali@linux-fr.org> wrote:
> > On Wed, 27 Jun 2012 21:54:10 +0800, Daniel Kurtz wrote:
> >> +
> >> +     if (timeout > MAX_RETRIES)
> >> +             dev_dbg(&priv->pci_dev->dev, "INTR Timeout!\n");
> >> +
> >> +     outb_p(status, SMBHSTSTS(priv));
> >
> > Wouldn't it be more correct to only write the INTR bit? Writing back
> > the whole 8 bits frightens me a little especially because of bit
> > INUSE_STS. If we ever want to support this feature, I think we have to
> > first ban writing back the whole status to register HST_STS. And this
> > is the only place where we still do AFAICS.
> 
> It looks like the current code does it this way to clear any error
> bits that may be set in the timeout case (errors set, but no INTR).
> For example, if there was a bus / arbitration error while waiting for
> PEC.
> 
> Perhaps we can split the difference (I tested this and it has no
> obvious regression):
> 
> +     /* Clear INTR, or in case of timeout, any other status bits. */
> +     outb_p(status & STATUS_FLAGS, SMBHSTSTS(priv));
> 
> But in a separate patch...
> 

I agree, this would be a reasonable compromise.

-- 
Jean Delvare
