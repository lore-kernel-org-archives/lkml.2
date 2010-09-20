Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab0ITPEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:04:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44709 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab0ITPEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:04:33 -0400
Date: Mon, 20 Sep 2010 16:04:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100920150431.GD31167@sirena.org.uk>
References: <20100920140049.31408.67527.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100920140049.31408.67527.stgit@localhost.localdomain>
X-Cookie: Stay the curse.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 03:01:06PM +0100, Alan Cox wrote:

> +static void *max3111_platform_data(void *info)
> +{
> +	static int dummy;
> +	struct spi_board_info *spi_info = (struct spi_board_info *)info;
> +	int intr = get_gpio_by_name("max3111_int");

> +/* we have multiple max7315 on the board ... */
> +#define MAX7315_NUM 2
> +static void *max7315_platform_data(void *info)

> +static void *emc1403_platform_data(void *info)
> +{

> +static void *lis331dl_platform_data(void *info)
> +{
> +	static short intr2nd_pdata;
> +	struct i2c_board_info *i2c_info = (struct i2c_board_info *)info;

It's rather concerning that the parser here needs to have all this
knowledge about the specific chips that will be on the boards.  Is there
a plan for how this will be managed once system integrators begin
putting other chips onto Moorestown boards?
