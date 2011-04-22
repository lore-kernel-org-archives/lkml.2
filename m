Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab1DVMw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:52:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24555 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1DVMwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:52:55 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: djwong <djwong@us.ibm.com>
Cc: Mingming Cao <cmm@us.ibm.com>, Christoph Hellwig <hch@infradead.org>,
        Jeff Layton <jlayton@redhat.com>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC v2] block integrity: Stabilize(?) pages during writeback
In-reply-to: <20110422000226.GA22189@tux1.beaverton.ibm.com>
References: <1300716666-sup-2087@think> <20110321164305.GC7153@quack.suse.cz> <20110406232938.GF1110@tux1.beaverton.ibm.com> <20110407165700.GB7363@quack.suse.cz> <20110408203135.GH1110@tux1.beaverton.ibm.com> <20110411124229.47bc28f6@corrin.poochiereds.net> <1302543595-sup-4352@think> <1302569212.2580.13.camel@mingming-laptop> <20110412005719.GA23077@infradead.org> <1302742128.2586.274.camel@mingming-laptop> <20110422000226.GA22189@tux1.beaverton.ibm.com>
Date: Fri, 22 Apr 2011 08:50:01 -0400
Message-Id: <1303476503-sup-4141@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DB179F1.00DC:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Darrick J. Wong's message of 2011-04-21 20:02:26 -0400:
> Hi everyone,
> 
> I've finally managed to get together a patch that seems to provide stable pages
> during writeback, or at least gets us to the point that after several days of
> running tests I don't see DIF checksum errors anymore. :)
> 
> The last two pieces to go into this puzzle were (a) bio_integrity_prep needs to
> walk the process tree to find all userland ptes that map to a particular memory
> page and revoke write access, and

Hmm, did you need the bio_integrity_prep change for all the filesystems?
This should be happening already as part of using page_mkwrite.

-chris
