Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab2LVJyP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 04:54:15 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35870 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2LVJyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 04:54:13 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V2] spi: remove check for bits_per_word on transfer from low level driver
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "baohua.song@csr.com" <baohua.song@csr.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "jonas.gorski@gmail.com" <jonas.gorski@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
In-Reply-To: <50D2AA43.8050106@nvidia.com>
References: <1355820943-25228-1-git-send-email-ldewangan@nvidia.com> <20121219162433.1E1E43E0BCF@localhost> <50D2AA43.8050106@nvidia.com>
Date: Sat, 22 Dec 2012 09:54:04 +0000
Message-Id: <20121222095404.420FC3E08BE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012 11:33:47 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> On Wednesday 19 December 2012 09:54 PM, Grant Likely wrote:
> > On Tue, 18 Dec 2012 14:25:43 +0530, Laxman Dewangan<ldewangan@nvidia.com>  wrote:
> >> The spi core make sure that each transfer structure have the proper
> >> setting for bits_per_word before calling low level transfer APIs.
> >>
> >> Hence it is no more require to check again in low level driver for
> >> this field whether this is set correct or not. Removing such code
> >> from low level driver.
> >>
> >> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> > [...]
> >> */
> >>
> >>   		if (prev_speed_hz != speed_hz
> >> @@ -316,9 +315,8 @@ static int txx9spi_transfer(struct spi_device *spi, struct spi_message *m)
> >>   	/* check each transfer's parameters */
> >>   	list_for_each_entry (t,&m->transfers, transfer_list) {
> >>   		u32 speed_hz = t->speed_hz ? : spi->max_speed_hz;
> >> -		u8 bits_per_word = t->bits_per_word ? : spi->bits_per_word;
> >> +		u8 bits_per_word = t->bits_per_word;
> >>
> >> -		bits_per_word = bits_per_word ? : 8;
> > Have you verified here that bits_per_word can never be '0' here? What is
> > the path that ensures spi->bits_per_word (and hence t->bits_per_word) is
> > set to 8 here?
> >
> > Otherwise the patch looks good. Thanks for doing this work.
> 
> 
> When we do the spi_add_device(), the spi_setup() get called.
> In spi_setup, it make  sure that spi->bits_per_word is not zero.
> 
> in spi_setup(spi.c)
> 
> if (!spi->bits_per_word)
>                  spi->bits_per_word = 8;

Applied, thanks.

g.

