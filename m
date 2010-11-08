Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0KHOjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:39:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51730 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab0KHOjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:39:52 -0500
Date: Mon, 8 Nov 2010 09:39:52 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFCv3 00/21] TCM Core and TCM_Loop patches for v2.6.37
Message-ID: <20101108143952.GB22121@infradead.org>
References: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some comments on the configfs to backend API:

 - the various get_*_info methods look like they really should use
   the seq_file API.  That gives you safety against overflows,
   and simplifies the code.
 - why are show_configfs_dev_params and get_dev_info separate
   methods if they always end up calling the same code?
 - the set_configfs_dev_params method implementation contains some
   rather nast parsing code.  They look like they really should use
   the parser.h helpers we use for mount option parsing.
