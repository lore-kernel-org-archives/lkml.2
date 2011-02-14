Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1BNCUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 21:20:21 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:27598 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754202Ab1BNCUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 21:20:15 -0500
Message-ID: <4D58917E.9050408@bluewatersys.com>
Date: Mon, 14 Feb 2011 15:20:46 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Chou <thomas@wytron.com.tw>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v9] spi: New driver for Altera SPI
References: <1297142509-20158-1-git-send-email-thomas@wytron.com.tw> <1297649443-11491-1-git-send-email-thomas@wytron.com.tw>
In-Reply-To: <1297649443-11491-1-git-send-email-thomas@wytron.com.tw>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2011 03:10 PM, Thomas Chou wrote:
> This patch adds a new SPI driver to support the Altera SOPC Builder
> SPI component. It uses the bitbanging library.
> 
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
> ---

> +struct altera_spi {
> +	/* bitbang has to be first */
> +	struct spi_bitbang bitbang;

Is this still true? I had a quick look and can't see anything which
relies on spi_bitbang being the first entry. Things like this should be
using container_of so that position in the struct is irrelevant.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
