Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab0H0MDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 08:03:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54770 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab0H0MDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 08:03:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Date: Fri, 27 Aug 2010 14:03:41 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: john stultz <johnstul@us.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>
References: <cover.1281956490.git.richard.cochran@omicron.at> <1282594899.3111.358.camel@localhost.localdomain> <20100827110855.GA11657@riccoc20.at.omicron.at>
In-Reply-To: <20100827110855.GA11657@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008271403.41949.arnd@arndb.de>
X-Provags-ID: V02:K0:EoDe23WKM4Uv+p6WFHBFGL7sCqtzzmcmAdOIg7tisyF
 bJ7gSfkChPqlDImADRypaFOuod/BdSwS+f4x3yOY6IDTaKaZPa
 YmMtYSdNNx9FKDfLMjPNl7ViEFPnBwgP5wWk0VcgFW85XuIrhA
 kncVy3oy2vYaWr401ZR3xrFtj92Kpbu2ybIjKMyqNX00uxZ0Pg
 RGFke2fKekVqBpyaZacgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 August 2010, Richard Cochran wrote:
> On Mon, Aug 23, 2010 at 01:21:39PM -0700, john stultz wrote:
> > On Thu, 2010-08-19 at 17:38 +0200, Richard Cochran wrote:
> > > On Thu, Aug 19, 2010 at 02:28:04PM +0200, Arnd Bergmann wrote:
> > > > Have you considered passing a struct timex instead of ppb and ts?
> > > 
> > > Yes, but the timex is not suitable, IMHO.
> > 
> > Could you expand on this?
> 
> We need to able to specify that the call is for a PTP clock. We could
> add that to the modes flag, like this:
> 
> /*timex.h*/
> #define ADJ_PTP_0 0x10000
> #define ADJ_PTP_1 0x20000
> #define ADJ_PTP_2 0x30000
> #define ADJ_PTP_3 0x40000
>
> I can live with this, if everyone else can, too.

My suggestion was actually to have a new syscall with the existing
structure, and pass a clockid_t value to it, similar to your
sys_clock_adjtime(), not change the actual sys_adjtime syscall.
  
> > Could we not add a adjustment mode ADJ_SETOFFSET or something that would
> > provide the instantaneous offset correction?
> 
> Yes, but we would also need to add a struct timespec to the struct
> timex, in order to get nanosecond resolution. I think it would be
> possible to do in the padding at the end?

Yes, that's exactly what the padding is for. Instead of timespec, you can
probably have a extra values for replacing the existing ppm values with
ppb values.

	Arnd
