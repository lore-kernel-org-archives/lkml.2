Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0JNJ7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:59:34 -0400
Received: from smtp101.sbc.mail.re3.yahoo.com ([66.196.96.84]:23813 "HELO
	smtp101.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755106Ab0JNJ7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:59:32 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: STk1SeEVM1loclaRM.8Un6LMvElHyDkaAvEGtye9Lb5g9J4
 JJGZyX05y0JCmp6rWsalrveTVL6Dadu5ob8QkzX6KoDqRoJT71FP1vj7aH1o
 nD8rqQCrvoyyJM00sDMy_sjqeGRdLa2BfYC6gVWaAz3NVVkCkzOlJLFsiEoY
 p6fudcWZzbidJcsCCuQ8Wo1KirTzUP9SYK9GC7civpOTe1KNIRf64iN2BE73
 Xa66ndLSuOw--
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
In-Reply-To: <20101014092601.GB28446@lst.de>
References: <1286959681-3445-1-git-send-email-nab@linux-iscsi.org>
	 <20101013110653.GA26366@lst.de>
	 <1287001189.7334.47.camel@haakon2.linux-iscsi.org>
	 <20101014000421.GB15583@lst.de>
	 <1287030937.9909.30.camel@haakon2.linux-iscsi.org>
	 <20101014092601.GB28446@lst.de>
Content-Type: text/plain
Date: Thu, 14 Oct 2010 02:54:47 -0700
Message-Id: <1287050087.9909.79.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 11:26 +0200, Christoph Hellwig wrote:
> On Wed, Oct 13, 2010 at 09:35:37PM -0700, Nicholas A. Bellinger wrote:
> > So you would rather have struct se_device attributes set in TCM
> > subsystem specific ->create_virtdevice() code directly after
> > transport_add_device_to_core_hba() -> se_dev_set_default_attribs(),
> > right..?
> 
> Actually you would want to set them before
> transport_add_device_to_core_hba.  Always make sure an object is fully
> set up before making it accessible.
> 

Hmmmm, very good point.

It would make the most sense to just go ahead and set a pre-configured
struct queue_limits into transport_add_device_to_core_hba() from
subsystem specific ->create_virtdevice() code, and just drop whatever
unnecessary struct se_subsystem_api ops are duplicate of what is being
registered as defaults with struct queue_limits.



