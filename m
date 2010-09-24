Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab0IXP1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 11:27:20 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:28201
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639Ab0IXP1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 11:27:19 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Sep 2010 11:27:19 EDT
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzz8275bhz2dh2a8h2a8h61h)
X-Spam-TCS-SCL: 0:0
Date: Fri, 24 Sep 2010 10:12:08 -0500
From: Scott Wood <scottwood@freescale.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: LEROY Christophe <christophe.leroy@c-s.fr>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] spi_mpc8xxx: issue with using definition of pram in
 Device Tree
Message-ID: <20100924101208.7916cfa9@udp111988uds.am.freescale.net>
In-Reply-To: <20100924075740.GA20599@oksana.dev.rtsoft.ru>
References: <20100916070503.10046C7391@messagerie.si.c-s.fr>
	<20100924071006.GA21318@angua.secretlab.ca>
	<4C9C513B.40501@c-s.fr>
	<20100924075740.GA20599@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Sep 2010 15:12:09.0831 (UTC) FILETIME=[DBD4F770:01CB5BFA]
X-Reverse-DNS: de01egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 11:57:40 +0400
Anton Vorontsov <cbouatmailru@gmail.com> wrote:

> Doesn't explain why that worked on MPC8272 (CPM2) and MPC8560
> (also CPM2) machines though. But here's my guess (I no longer
> have these boards to test it):
> 
> On 8272 I used this node:
> 
> +                       spi@4c0 {
> +                               #address-cells = <1>;
> +                               #size-cells = <0>;
> +                               compatible = "fsl,cpm2-spi", "fsl,spi";
> +                               reg = <0x11a80 0x40 0x89fc 0x2>;
> 
> On that SOC there are two muram data regions 0x0..0x2000 and
> 0x9000..0x9100. Note that we actually don't want "data" regions,
> and the only reason why that worked is that sysdev/cpm_common.c
> maps muram(0)..muram(max).

Wouldn't it still fail the rh_alloc_fixed call?

-Scott

