Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0IGAvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 20:51:40 -0400
Received: from smtp103.sbc.mail.ac4.yahoo.com ([76.13.13.242]:35466 "HELO
	smtp103.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752968Ab0IGAve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 20:51:34 -0400
X-Greylist: delayed 1600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Sep 2010 20:51:33 EDT
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: LvKVh9YVM1k7.H.sRMl8zJmOGnUJPjFJtSlgGASKiR8UcOq
 zkDrp8cNW1KNa1TJaY0l35T3zV6v_1vGw.9oFYiyyEMaU9BpfzMmdTU2i8d_
 z45xQfxIk3ZJTQOR6IyICdwQq3V4L3BJ_UV8ToJKRXXcfhaYu7KjgIvVxe_H
 6CdbG8z5tQ3gYaP.MuUSf9YE6VJUVAIFJhWvfs6uhIJXezs.c7V6xJ79cS5a
 .1sUtPLCGTWRZGM80ZDgkHQ8xopE7hbrIdrQ5SPV_8.88arC_Egm5in6x.22
 ZUM0X.6cpfNNq777BRE5kC5X9im6YlsHdCLjXbcnSEkoX.r34smmnfNm2CY8
 pXVxX735Fm9CZRZ4hLQ--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH v2] scsi_debug: Convert to use root_device_register()
	and root_device_unregister()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>, Greg KH <greg@kroah.com>
In-Reply-To: <20100907001342.GB20882@core.coreip.homeip.net>
References: <1283817551-23380-1-git-send-email-nab@linux-iscsi.org>
	 <20100907001342.GB20882@core.coreip.homeip.net>
Content-Type: text/plain
Date: Mon, 06 Sep 2010 17:20:53 -0700
Message-Id: <1283818853.556.253.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-06 at 17:13 -0700, Dmitry Torokhov wrote:
> On Mon, Sep 06, 2010 at 04:59:11PM -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi Dough and Co,
> > 
> > This patch updates the scsi_debug virtual LLD to use root_device_register()
> > and root_device_unregister() from include/linux/device.h instead of device_register()
> > and device_unregister() respectively within scsi_debug_init() and scsi_debug_exit()
> > This simply involved converting the static struct device pseudo_primary into a
> > pointer that is setup by the call to root_device_register().
> > 
> > This patch also contains the correct IS_ERR() conditional check of
> > root_device_register() from within scsi_debug_init().
> > 
> > Thanks to Richard Sharpe and Dmitry Torokhov for their help with this item.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/scsi/scsi_debug.c |   27 +++++++++------------------
> >  1 files changed, 9 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index b02bdc6..86d483e 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -3207,23 +3207,14 @@ static void do_remove_driverfs_files(void)
> >  	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_add_host);
> >  }
> >  
> > -static void pseudo_0_release(struct device *dev)
> > -{
> > -	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
> > -		printk(KERN_INFO "scsi_debug: pseudo_0_release() called\n");
> > -}
> > -
> > -static struct device pseudo_primary = {
> > -	.init_name	= "pseudo_0",
> > -	.release	= pseudo_0_release,
> > -};
> > +struct device *pseudo_primary;
> >  
> >  static int __init scsi_debug_init(void)
> >  {
> >  	unsigned long sz;
> >  	int host_to_add;
> >  	int k;
> > -	int ret;
> > +	int ret = 0;
> 
> Please drop this chunk, it is not needed and is dangerous WRT future
> changes to the file as I explained earlier.

As you wish..

Best,

--nab

