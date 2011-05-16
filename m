Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab1EPTw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:52:59 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:53291 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216Ab1EPTw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:52:58 -0400
Date: Mon, 16 May 2011 15:52:58 -0400
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Hu Mingkai-B21284 <B21284@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: Re: spi_fsl_spi broken when compiled as module by
 b36ece832512c1a0afa54ff0a56d63492a1caf08
Message-ID: <20110516195258.GL21345@caffeine.csclub.uwaterloo.ca>
References: <20110511155211.GA21349@caffeine.csclub.uwaterloo.ca>
 <9389EE59E16E9447AFB481039183BCF4117B10@039-SN1MPN1-005.039d.mgd.msft.net>
 <20110512151113.GE21345@caffeine.csclub.uwaterloo.ca>
 <BANLkTikGM=v09KE-J_KOvbSNhQx3MmR0cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikGM=v09KE-J_KOvbSNhQx3MmR0cA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 12:17:13PM -0600, Grant Likely wrote:
> On Thu, May 12, 2011 at 9:11 AM, Lennart Sorensen
> <lsorense@csclub.uwaterloo.ca> wrote:
> > On Thu, May 12, 2011 at 01:33:55AM +0000, Hu Mingkai-B21284 wrote:
> >> Please submit a patch to modify it.
> >
> > OK.  Here it is.
> 
> >
> > --
> > Len Sorensen
> >
> > Add missing exports and module license to allow compiling of spi_fsl_*
> > drivers as modules again.  Originally broken by refactoring of code in
> > b36ece832512c1a0afa54ff0a56d63492a1caf08.
> >
> > diff --git a/drivers/spi/spi_fsl_lib.c b/drivers/spi/spi_fsl_lib.c
> > index ff59f42..d7efaac 100644
> > --- a/drivers/spi/spi_fsl_lib.c
> > +++ b/drivers/spi/spi_fsl_lib.c
> > @@ -48,16 +48,23 @@ u32 mpc8xxx_spi_tx_buf_##type(struct mpc8xxx_spi *mpc8xxx_spi)      \
> >  }
> >
> >  MPC8XXX_SPI_RX_BUF(u8)
> > +EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u8);
> >  MPC8XXX_SPI_RX_BUF(u16)
> > +EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u16);
> >  MPC8XXX_SPI_RX_BUF(u32)
> > +EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u32);
> >  MPC8XXX_SPI_TX_BUF(u8)
> > +EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u8);
> >  MPC8XXX_SPI_TX_BUF(u16)
> > +EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u16);
> >  MPC8XXX_SPI_TX_BUF(u32)
> > +EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u32);
> 
> EXPORT_SYMBOL_GPL() please.

OK.  I never know when that should be used.  Seems to me it should either
be everywhere or nowhere.

> >
> >  struct mpc8xxx_spi_probe_info *to_of_pinfo(struct fsl_spi_platform_data *pdata)
> >  {
> >        return container_of(pdata, struct mpc8xxx_spi_probe_info, pdata);
> >  }
> > +EXPORT_SYMBOL(to_of_pinfo);
> 
> Hmmm,. this is not so good because it exports rather generically named
> functions out to the global namespace.  These functions should be
> renamed to have an mpc8xxx_spi_ prefix before exporting.
> 
> Otherwise this patch looks good.

Hmm, yeah it did look like a crappy function name, but I just wanted to
fix the problem, not try to guess what the author of the code intended.
Prefixing it makes sense.

-- 
Len Sorensen
