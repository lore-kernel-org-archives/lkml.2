Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab0C3Skw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:40:52 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:58923 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab0C3Sku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:40:50 -0400
Date: Tue, 30 Mar 2010 20:40:46 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alagu Sankar <alagusankar@embwise.com>,
       Volker Ernst <volker.ernst@txtr.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Holger Schurig <hs4233@mail.mn-solutions.de>,
       Bing Zhao <bzhao@marvell.com>, libertas-dev@lists.infradead.org,
       linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH] libertas/sdio: set ECSI and SCSI bits for 1-bit
 transfers
Message-ID: <20100330184046.GY30801@buzzloop.caiaq.de>
References: <1269970733-24681-1-git-send-email-daniel@caiaq.de>
 <1269974259.3019.52.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269974259.3019.52.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 11:37:39AM -0700, Dan Williams wrote:
> On Tue, 2010-03-30 at 19:38 +0200, Daniel Mack wrote:
> > When operating in 1-bit mode, SDAT1 is used as dedicated interrupt line.
> > However, the 8686 will only drive this line when the ECSI and SCSI bits
> > are set in the CCCR_IF register.
> 
> While this looks fine enough to me, I don't have enough knowledge of the
> SDIO stack to know whether or not this would be considered a layering
> violation or not.  Given that I don't think there's an active maintainer
> for the SDIO subsystem though, I'd say it's fine enough for me...
> 
> Any thoughts David since it appears to be at least somewhat SPI related?

I believe that these bits in question are just abused in this case. The
device is not in SPI mode, so according to the specs, the bits shouldn't
make any difference. This makes me think that this is specific to
libertas, and doesn't belong in any lower level.

> Acked-by: Dan Williams <dcbw@redhat.com>

Thanks!

Daniel

