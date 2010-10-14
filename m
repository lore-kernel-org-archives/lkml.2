Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab0JNEkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:40:24 -0400
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.207]:30601 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754534Ab0JNEkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:40:23 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 3gJKiCMVM1mxkuKIfG0YACKkyUiBzjkDUHCV_B8MDfezwMO
 pNooD4a9rLzC7uuqlYoqY4eni2bnIXawwpal_9WSa83WvwtyCtpwymmVoQI2
 RdN5mkbdGoZLod60sSUqGgm3yHa9Sc6qm8MNgiV6kE4T4cSXx0iBpr180WkI
 XGotm4zu7UK2.JlbNq6HUru8Tqk1qo0_s2OfElBjLCrKKjBclgDSvRJkLoif
 ttn9EGF5KOOy4stjaxe6VfCRwL.pXTFCQliGm33NxiLm7NS16hqBJvAg6Io5
 kIBR.47pG6pxrv3sDfqciDB0-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 2/5] tcm: Unify INQUIRY subsystem plugin handling
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>
In-Reply-To: <20101014000421.GB15583@lst.de>
References: <1286959681-3445-1-git-send-email-nab@linux-iscsi.org>
	 <20101013110653.GA26366@lst.de>
	 <1287001189.7334.47.camel@haakon2.linux-iscsi.org>
	 <20101014000421.GB15583@lst.de>
Content-Type: text/plain
Date: Wed, 13 Oct 2010 21:35:37 -0700
Message-Id: <1287030937.9909.30.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 02:04 +0200, Christoph Hellwig wrote:
> On Wed, Oct 13, 2010 at 01:19:49PM -0700, Nicholas A. Bellinger wrote:
> > I should point out that the majority of values mentioned here (other
> > than the two INQUIRY strings) are already present in struct
> > se_dev_attrib and which appear as configfs attributes under
> > under /sys/kernel/config/target/core/$HBA/$DEV/attrib/.  This means that
> > the struct se_subsystem_api calls only really used by during init
> > target_core_device.c:se_dev_set_default_attribs() and
> > DEV_ATTRIB(dev)->block_size, etc are used in TCM Core code.
> > 
> > I am happy to include the two INQUIRY strings needed for emulation into
> > struct se_subsystem_api directly, but I would still prefer to keep the
> > function pointers for extracting values from subsystem specific code for
> > the initial device attribute setup.
> 
> What's the point?  It's a lot of boilerplate code that does nothing
> but obsfucating what's actually going on there.
> 

So you would rather have struct se_device attributes set in TCM
subsystem specific ->create_virtdevice() code directly after
transport_add_device_to_core_hba() -> se_dev_set_default_attribs(),
right..?

Performing the assignment of these attribute values from the same local
functions and dropping the extra struct se_subsystem_api callers would
be fine with me, but I honestly don't see how these handful of subsystem
API callers with obvious names adds obsfucation while TCM code is using
struct se_device->$ATTR_NAME to enforce device limits in I/O path
code...?

Thanks for your comments.. ;)

--nab

