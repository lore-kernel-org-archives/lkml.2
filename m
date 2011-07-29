Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1G2CIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 22:08:54 -0400
Received: from outgw02.ricoh.co.jp ([202.248.73.5]:41108 "EHLO
	outgw02.ricoh.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab1G2CIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 22:08:53 -0400
In-Reply-To: <m2r559di9y.fsf@bob.laptop.org>
Subject: Re: [PATCH] [9/50] mmc: Added quirks for Ricoh 1180:e823 lower base clock
To: cjb@laptop.org
Cc: ak@linux.intel.com, Andi Kleen <andi@firstfloor.org>,
        daniel.manrique@canonical.com, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, manoj.iyer@canonical.com,
        stable@kernel.org, tim.bird@am.sony.com
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
Message-ID: <OF5CBC52FF.5B5957D9-ON492578DC.00093451-492578DC.000BCC8B@mta.ricoh.co.jp>
From: matsumur@nts.ricoh.co.jp
Date: Fri, 29 Jul 2011 11:10:45 +0900
X-MIMETrack: Serialize by Router on ZGMTA07/G/RGroup(Release 7.0.2FP1 HF237|April 25, 2007) at
 2011/07/29 11:08:51
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

> Do you know of a better solution than always lowering the clock speed to
> 50MHz for this controller?

Yes, it is a better solution.
As you know, SD ver.1.1 and 2.0(SDHC) cards can be applied 50MHz SD-CLK..
SD 3.0 (UHS-I) cards also can be applied 50Mhz. However UHS-I cards are
available 200 or 100Mhz SD-CLK.
I would like to know if the current SD Host driver has the function of
setting SD-CLK to 200Mhz for SD ver3.0 compliant Host Controller.


Thanks,


Koji Matsumuro
Ricoh Company,Ltd.


Chris Ball <cjb@laptop.org> wrote on 2011/07/29 09:47:53:

> Hi,

> On Thu, Jul 28 2011, Andi Kleen wrote:
> > On Fri, Jul 29, 2011 at 09:27:56AM +0900, matsumur@nts.ricoh.co.jp
wrote:
> >> Dear Sir,
> >>
> >> Ricoh 1180:e823 device is named R5U220/R5U232 (2 devices have the same
> >> device ID ).
> >> So, I think it should be declared to as PCI_DEVICE_ID_RICOH_R5U220.
> >
> > Is that just the wrong name or will it actually cause misfunction?

> I don't think it could possibly cause misfunction; it's just a macro
name.

> > BTW, does anyone know whether the current SDHCI-driver sets 200Mhz to
> > SD-CLK for UHS-I cards ?

> The Linux 3.1 SD driver will set the SD-CLK to 50MHz for every card on an
> e823 device, and older kernels will do so too once the commit has been
> applied to the stable trees.  See this commit:

> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;
> a=commitdiff;h=15bed0f2fa8e1d7db201692532c210a7823d2d21

> Do you know of a better solution than always lowering the clock speed to
> 50MHz for this controller?

> Thanks,

> - Chris.
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child

