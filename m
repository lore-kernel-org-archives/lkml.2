Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab1DKSkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 14:40:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60267 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab1DKSkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 14:40:35 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Layton <jlayton@redhat.com>, djwong <djwong@us.ibm.com>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Joel Becker <jlbec@evilplan.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation problem
In-reply-to: <20110411182541.GA29511@infradead.org>
References: <20110308045626.GD1956@dastard> <20110319000755.GD1110@tux1.beaverton.ibm.com> <20110321140451.GA7153@quack.suse.cz> <1300716666-sup-2087@think> <20110321164305.GC7153@quack.suse.cz> <20110406232938.GF1110@tux1.beaverton.ibm.com> <20110407165700.GB7363@quack.suse.cz> <20110408203135.GH1110@tux1.beaverton.ibm.com> <20110411124229.47bc28f6@corrin.poochiereds.net> <1302543595-sup-4352@think> <20110411182541.GA29511@infradead.org>
Date: Mon, 11 Apr 2011 14:38:30 -0400
Message-Id: <1302547069-sup-103@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DA34AFC.00BF:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Christoph Hellwig's message of 2011-04-11 14:25:41 -0400:
> On Mon, Apr 11, 2011 at 01:41:16PM -0400, Chris Mason wrote:
> > Actually this isn't a nit.  Keeping the page locked closes an important
> > hole where it can become writeback again.  It might fix the last
> > remaining problem.
> 
> Note that the generic block_page_mkwrite atually does that.  But only
> xfs and nilfs2 actually make use of it.
> 

Btrfs does return VM_FAULT_LOCKED though.  I had forgotten to look for
this in the ext4 page_mkwrite call.

-chris
