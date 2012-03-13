Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab2CMXrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:47:03 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50852 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab2CMXrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:47:00 -0400
Date: Wed, 14 Mar 2012 03:46:56 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add I2C driver for Summit Microelectronics SMB347
 Battery Charger.
Message-ID: <20120313234656.GA1778@oksana.dev.rtsoft.ru>
References: <20120206155729.9947.22792.stgit@bob.linux.org.uk>
 <20120206160127.GF10173@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120206160127.GF10173@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 04:01:27PM +0000, Mark Brown wrote:
> On Mon, Feb 06, 2012 at 03:59:01PM +0000, Alan Cox wrote:
> 
> > Driver support for the Summit I??C battery charger. This is used in some
> > Intel devices.
> 
> There's quite a lot of read/modify/write cycles and...
> 
> > +static int smb347_debugfs_show(struct seq_file *s, void *data)
> > +{
> > +	struct smb347_charger *smb = s->private;
> > +	int ret;
> > +	u8 reg;
> > +
> > +	seq_printf(s, "Control registers:\n");
> > +	seq_printf(s, "==================\n");
> 
> ...this which make me wonder if this might not benefit from using
> regmap.  The read/modify/write cycles are handled by regmap_update_bits()
> and there's a standard debugfs file for dumping registers.  Should save
> a bit of code I think but I'd not worry too much either way.
> 
> > +static int __init smb347_init(void)
> > +{
> > +	return i2c_add_driver(&smb347_driver);
> > +}
> > +module_init(smb347_init);
> > +
> > +static void __exit smb347_exit(void)
> > +{
> > +	i2c_del_driver(&smb347_driver);
> > +}
> > +module_exit(smb347_exit);
> 
> There's module_i2c_driver() (and similarly for SPI and platform) though
> that's definitely a nitpick.

I agree with all these comments. There wasn't any update on this
patch though. But it compiles and hopefully works, so I'm applying it
w/ some lingering hope that it'll receive attention from the submitter. :-)

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
