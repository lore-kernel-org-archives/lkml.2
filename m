Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab0I2JNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 05:13:16 -0400
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:39744 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755008Ab0I2JNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 05:13:15 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: fRM7HykVM1lOUAIb2sJNWCPfHsaOmy02l7EO2MMXVl7f5DK
 5VaTzU68df1RQpCovPdWO9izcdE8mwieEpWMk60p2FEN.SiWWq64ES1.B8Z7
 LVHbXmhZGMEVpDiA0af0uHppUYZgehtwuf2C8RwYSJmRGlv0J6yVNuhVAkbY
 phzisSnge36s20fg6gOnBQFJKKZQtiR4rmkMO0RU.uBhSGXmwp3aEk0c4VJo
 qxNuaWr125FNtF8_8wzmM714.oM0RxzQiKJ0E9z9G84UIZFXFxNlE9mf0_Cn
 op0W22aCly8VKfqUHD0jmcxA-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 3/3] tcm/fileio: Add UNMAP / Block DISCARD support
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Richard Sharpe <realrichardsharpe@gmail.com>
In-Reply-To: <4CA2FF94.8020800@panasas.com>
References: <1285627910-6492-1-git-send-email-nab@linux-iscsi.org>
	 <4CA18F28.3070608@panasas.com>
	 <1285747739.18417.49.camel@haakon2.linux-iscsi.org>
	 <4CA2FF94.8020800@panasas.com>
Content-Type: text/plain
Date: Wed, 29 Sep 2010 02:08:57 -0700
Message-Id: <1285751337.18417.61.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 10:57 +0200, Boaz Harrosh wrote:
> On 09/29/2010 10:08 AM, Nicholas A. Bellinger wrote:
> > On Tue, 2010-09-28 at 08:46 +0200, Boaz Harrosh wrote:
> >>> +			printk(KERN_WARNING "Ignoring UNMAP for non BD"
> >>> +					" backend for struct file\n");
> >>
> >> TODO: Lots of extent based filesystems could enjoy if you punch an hole
> >>       in the file. (Which will also send a proper discard).
> >>       So how to punch an hole in a file via vfs?
> > 
> > Good question, as all of the current block discard support assumes a
> > struct block_device * pointer currently.
> > 
> > I know that hch has mentioned that accesing a struct block_device from
> > struct file is very dangerous, but I am assuming for the TCM/FILEIO case
> > that this code will be protected by igrab() and iput().
> > 
> > hch and jaxboe, any comments here..?
> > 
> 
> No you did not understand. FILEIO (working on a filesystem's real file),
> should *never* attempt a discard on the blocks even if it was
> to read the file's map and figure out these blocks. It should always
> call a filesystem specific API that puntches-an-hole in the file.

Mmmm, then I will have to defer to the FS folks on this particular item
then.

> Fore stupid filesystem that means fill with zero's. For a smart
> extent-based file system it means splitting up the extents the range
> belongs to and freeing up the block that where allocated for that
> range. But it is an heavy meta-data operation that only the filesystem
> can do. With really smart FS like xfs the unallocated blocks also
> get discarded, for when working with SANs with over provisioning.
> 

Ok, that makes sense.. But I guess I am still lost on how this could
actually be done for the !(S_ISBLK) struct file case..?

Best,

--nab


