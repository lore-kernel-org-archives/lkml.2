Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0IEVzU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 17:55:20 -0400
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:48294 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754488Ab0IEVzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 17:55:18 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 8ZRPnEAVM1mdywfnMhqeH7jDxb02cZapVRTLA4t_ATthsK0
 B31a.cGOv4RcE.4QS8EHWSbCR1rtpLDWwgdiB_bPXL1lb.EbrqHGDnW_RFLl
 c66preTFcrTdX1L1f..iqcZ2TlxwKZ6WVXjMRwEsi_8eGant7sX6gF7cXHsq
 B__UypdLRU1Q_E_gPi5WRwwua4Wkr5GELEZGbRo2V.Qcm6FOyoguXeiuQCWx
 3eDycjydHphrU90mnLm4a03nOLGB5bEoAcwbUXu7DjB0I5jpaBp3DcjBAbCC
 1_nd4DZrW7pw7F4tlNTmzK9w-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [RFC 22/22] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
	module
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>
In-Reply-To: <20100905203006.GD18411@core.coreip.homeip.net>
References: <1283160203-6981-1-git-send-email-nab@linux-iscsi.org>
	 <20100905203006.GD18411@core.coreip.homeip.net>
Content-Type: text/plain
Date: Sun, 05 Sep 2010 14:51:19 -0700
Message-Id: <1283723479.556.135.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-05 at 13:30 -0700, Dmitry Torokhov wrote:
> On Mon, Aug 30, 2010 at 02:23:23AM -0700, Nicholas A. Bellinger wrote:
> > +
> > +static void tcm_loop_primary_release(struct device *dev)
> > +{
> > +	return;
> > +}
> > +
> > +static struct device tcm_loop_primary = {
> > +	.init_name		= "tcm_loop_0",
> > +	.release		= tcm_loop_primary_release,
> > +};
> > +
> 
> No, you can not have statically allocated devices and dummy release
> functions.
> 

Last time I checked this is still what mainline
drivers/scsi/scsi_debug.c is doing for struct device pseudo_primary:

static void pseudo_0_release(struct device *dev)
{
        if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
                printk(KERN_INFO "scsi_debug: pseudo_0_release() called\n");
}

static struct device pseudo_primary = {
        .init_name      = "pseudo_0",
        .release        = pseudo_0_release,
};

so for these type of things in TCM_Loop I tend to follow what scsi_debug does,
 so I don't exactly see a issue here atm.  Anybody else have comments..?

Best,

--nab

