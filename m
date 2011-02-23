Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab1BWR1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:27:05 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:50335
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470Ab1BWR1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:27:01 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzzz2dh2a8h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
Date: Wed, 23 Feb 2011 11:26:12 -0600
From: Scott Wood <scottwood@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Richard Cochran <richardcochran@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rodolfo Giometti <giometti@linux.it>, Arnd Bergmann <arnd@arndb.de>,
        Peter Zijlstra <peterz@infradead.org>, <linux-api@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, <netdev@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Christoph Lameter <cl@linux.com>,
        <linuxppc-dev@lists.ozlabs.org>, David Miller <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH V11 2/4] ptp: Added a clock that uses the eTSEC found on
 the MPC85xx.
Message-ID: <20110223112612.30071995@schlenkerla>
In-Reply-To: <20110223165058.GE14597@angua.secretlab.ca>
References: <cover.1298447722.git.richard.cochran@omicron.at>
	<be1f5e801e8cd0145dd23aadae7c2055bb3c1d47.1298447722.git.richard.cochran@omicron.at>
	<20110223165058.GE14597@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 09:50:58 -0700
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Wed, Feb 23, 2011 at 11:38:17AM +0100, Richard Cochran wrote:
> > +
> > +* Gianfar PTP clock nodes
> > +
> > +General Properties:
> > +
> > +  - compatible   Should be "fsl,etsec-ptp"
> 
> Should specify an *exact* part; ie: "fsl,mpc8313-etsec-ptp" instead of
> trying to define a generic catchall.  The reason is that the same
> marketing name can end up getting applied to a wide range of parts.
> 
> Instead, choose one specific device to stand in as the 'common'
> implementation and get all parts with the same core to claim
> compatibility with it.  ie: a p2020 might have:
> 
> 	compatible = "fsl,mpc2020-etsec-ptp", "fsl,mpc8313-etsec-ptp";

eTSEC is versioned, that's more reliable than the chip name since chips
have revisions (rev 2.1 of mpc8313 has eTSEC 1.6, not sure about previous
revs of mpc8313).  Logic blocks can be and have been uprevved between one
revision of a chip to the next.  I think "fsl,mpc8313rev2.1-etsec-ptp"
would be taking things a bit too far (and there could be board-level bugs
too...).

If you really need to know the exact SoC you're on, look in SVR (which
will provide revision info as well).  Isn't the device tree for things that
can't be probed?

The eTSEC revision is probeable as well, but due the way PTP is described as
a separate node, the driver doesn't have straightforward access to those
registers.

Insisting on an explicit chip also encourages people to claim compatibility
with that chip without ensuring that it really is fully compatible.

-Scott

