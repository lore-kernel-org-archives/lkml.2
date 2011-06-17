Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab1FQOFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:05:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60211 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758993Ab1FQOFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:05:04 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: Re: [alsa-devel] [PATCH v5 15/18] ASoC: twl6040: Remove pll and headset mode dependency
Date: Fri, 17 Jun 2011 16:04:34 +0300
Message-ID: <3587033.yBnh7UpTkW@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110617132759.GB4951@sirena.org.uk>
References: <1307983070-2257-1-git-send-email-peter.ujfalusi@ti.com> <1307983070-2257-16-git-send-email-peter.ujfalusi@ti.com> <20110617132759.GB4951@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 June 2011 15:27:59 Mark Brown wrote:
> On Mon, Jun 13, 2011 at 07:37:47PM +0300, Peter Ujfalusi wrote:
> > From: Misael Lopez Cruz <misael.lopez@ti.com>
> > 
> > Remove dependency between pll (hppll, lppll) and headset power
> > mode (low-power, high-performance), as headset power mode can
> > be used with any pll.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> but...
> 
> > A new control is created to allow headset power mode configuration
> > from userspace. Changing headset power mode during earpiece related
> > usecases is not allowed as earpiece requires HS DAC in HP mode.
> 
> Might be nicer to allow the user to set the control given that you'll
> just ignore the configured value anyway if it's not usable right now.

Yeah, we can allow the change, but skip the register updates for use cases 
when it is not allowed.

I did spot other issue related to this power mode handling: the DAPM event 
handler has been attached to HFDAC, and not to the HSDAC, so the refcounting 
is done for a wrong set of DAC... The HFDACs has no relationship with the 
Earpiece output (it is connected to HSDACL).

-- 
Péter
