Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab1BOTnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 14:43:04 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:54682 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab1BOTnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 14:43:01 -0500
Date: Tue, 15 Feb 2011 12:42:57 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v9] spi: New driver for Altera SPI
Message-ID: <20110215194257.GB7649@angua.secretlab.ca>
References: <1297142509-20158-1-git-send-email-thomas@wytron.com.tw>
 <1297649443-11491-1-git-send-email-thomas@wytron.com.tw>
 <4D58917E.9050408@bluewatersys.com>
 <4D5A2591.5090901@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5A2591.5090901@wytron.com.tw>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 03:04:49PM +0800, Thomas Chou wrote:
> Dear Ryan,
> 
> On 02/14/2011 10:20 AM, Ryan Mallon wrote:
> >On 02/14/2011 03:10 PM, Thomas Chou wrote:
> >>This patch adds a new SPI driver to support the Altera SOPC Builder
> >>SPI component. It uses the bitbanging library.
> >>
> >>Signed-off-by: Thomas Chou<thomas@wytron.com.tw>
> >>---
> >
> >>+struct altera_spi {
> >>+	/* bitbang has to be first */
> >>+	struct spi_bitbang bitbang;
> >
> >Is this still true? I had a quick look and can't see anything which
> >relies on spi_bitbang being the first entry. Things like this should be
> >using container_of so that position in the struct is irrelevant.
> >
> >~Ryan
> >
> 
> Yes, sadly true. This is due to the implementation of the bitbanging
> library, spi_bitbang.c, which assumes the struct spi_bitbang is the
> first of drvdata. Though it could be changed in the future (beyond
> this little driver), every bitbanging library user has to follow
> this for now.

Should be easy to fix if it is indeed still true (I haven't dug deep
enough to find the design error yet).  Anybody want to volunteer?

g.

