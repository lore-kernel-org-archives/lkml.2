Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab2BFQBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:01:31 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52993 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab2BFQBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:01:30 -0500
Date: Mon, 6 Feb 2012 16:01:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: cbou@mail.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add I2C driver for Summit Microelectronics SMB347
 Battery Charger.
Message-ID: <20120206160127.GF10173@sirena.org.uk>
References: <20120206155729.9947.22792.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206155729.9947.22792.stgit@bob.linux.org.uk>
X-Cookie: To err is human, to forgive unusual.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 03:59:01PM +0000, Alan Cox wrote:

> Driver support for the Summit I??C battery charger. This is used in some
> Intel devices.

There's quite a lot of read/modify/write cycles and...

> +static int smb347_debugfs_show(struct seq_file *s, void *data)
> +{
> +	struct smb347_charger *smb = s->private;
> +	int ret;
> +	u8 reg;
> +
> +	seq_printf(s, "Control registers:\n");
> +	seq_printf(s, "==================\n");

...this which make me wonder if this might not benefit from using
regmap.  The read/modify/write cycles are handled by regmap_update_bits()
and there's a standard debugfs file for dumping registers.  Should save
a bit of code I think but I'd not worry too much either way.

> +static int __init smb347_init(void)
> +{
> +	return i2c_add_driver(&smb347_driver);
> +}
> +module_init(smb347_init);
> +
> +static void __exit smb347_exit(void)
> +{
> +	i2c_del_driver(&smb347_driver);
> +}
> +module_exit(smb347_exit);

There's module_i2c_driver() (and similarly for SPI and platform) though
that's definitely a nitpick.
