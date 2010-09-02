Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab0IBGwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 02:52:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20429 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab0IBGwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 02:52:02 -0400
Date: Wed, 1 Sep 2010 23:48:15 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC 02/22] configfs: Add struct
 configfs_item_operations->check_link() in configfs_unlink()
Message-ID: <20100902064814.GB27904@mail.oracle.com>
Mail-Followup-To: Konrad Rzeszutek Wilk <konrad@darnok.org>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	linux-scsi <linux-scsi@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Mike Christie <michaelc@cs.wisc.edu>,
	Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
	James Bottomley <James.Bottomley@suse.de>,
	Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>
References: <1283160025-6598-1-git-send-email-nab@linux-iscsi.org>
 <201009020031.08750.konrad@darnok.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009020031.08750.konrad@darnok.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 12:31:07AM -0400, Konrad Rzeszutek Wilk wrote:
> On Monday 30 August 2010 05:20:25 Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch adds a optional struct configfs_item_operations->check_link()
> > check called in fs/configfs/symlink.c:configfs_unlink() that can be used by
> > configfs consumers to check for an explict struct config_group dependence
> > with active symlink and fail with -EPERM before the unlink(2) syscall is
> > allowed to occur.
> >
> > Currently without this patch, there is not a method that a consumer can
> > tell configfs_unlink() that it needs to fail for this particular case. 
> > Allowing ->check_link() to propigate up the errno to VFS is also another
> > option for the call, but currently for TCM using the existing -EPERM in
> > configfs_unlink() is fine here.
> >
> > Note this patch is used by TCM v4 generic configfs fabric module
> > infrastructure to allow  explict Initiator Port MappedLUNs symlinks to
> > create a dependency for the fabric TPG Port LUNs living in a configfs group
> > that is not a direct struct config_group parent.
> >
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

	I NAK'd this a while back.  I'm willing to be convinced, but so
far it remains that way.

Joel

-- 

Life's Little Instruction Book #109

	"Know how to drive a stick shift."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
