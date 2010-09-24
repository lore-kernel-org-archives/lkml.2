Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0IXPHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 11:07:47 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:19603
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755029Ab0IXPHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 11:07:46 -0400
X-SpamScore: -13
X-BigFish: VS-13(zz1411I1432N98dNzz1202hzzz2dh2a8h2a8h61h)
X-Spam-TCS-SCL: 0:0
Date: Fri, 24 Sep 2010 10:07:35 -0500
From: Scott Wood <scottwood@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: christophe leroy <christophe.leroy@c-s.fr>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] spi_mpc8xxx: issue with using definition of pram in
 Device Tree
Message-ID: <20100924100735.47b49580@udp111988uds.am.freescale.net>
In-Reply-To: <20100924071006.GA21318@angua.secretlab.ca>
References: <20100916070503.10046C7391@messagerie.si.c-s.fr>
	<20100924071006.GA21318@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Sep 2010 15:07:36.0768 (UTC) FILETIME=[3912DC00:01CB5BFA]
X-Reverse-DNS: de01egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 01:10:06 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Thu, Sep 16, 2010 at 09:05:03AM +0200, christophe leroy wrote:
> > This patch applies to 2.6.34.7 and 2.6.35.4
> > It fixes an issue during the probe for CPM1 with definition of parameter ram from DTS
> > 
> > Signed-off-by: christophe leroy <christophe.leroy@c-s.fr>
> 
> I'm sorry, I don't understand the fix from the given description.
> What is the problem, and why is cpm_muram_alloc_fixed() the wrong
> thing to call on CPM1?  Does CPM2 still need it?

I don't see how cpm_muram_alloc_fixed() can be used safely at all.  If
you need a fixed address, it shouldn't be part of the general
allocation pool, or something else might get it first.

-Scott

