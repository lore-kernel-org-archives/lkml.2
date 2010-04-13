Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab0DMSDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:03:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0DMSDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:03:14 -0400
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
From: Peter Zijlstra <peterz@infradead.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: =?ISO-8859-1?Q?H=E5kon?= Bugge <Haakon.Bugge@Sun.COM>,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric B Munson <ebmunson@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rdma@vger.kernel.org, rolandd@cisco.com, pavel@ucw.cz,
       mingo@elte.hu, jsquyres@cisco.com
In-Reply-To: <adahbnfme0j.fsf@roland-alpha.cisco.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
	 <20100412160359.1d9074dc.akpm@linux-foundation.org>
	 <20100412235937.GF15629@obsidianresearch.com>
	 <3251DDDA-D705-4B1E-9595-9C24709EF146@Sun.com>
	 <adahbnfme0j.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 13 Apr 2010 20:02:54 +0200
Message-ID: <1271181774.4807.1868.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 10:57 -0700, Roland Dreier wrote:
> Are those system calls the only possible way that virtual to physical
> mappings can change?  Can't page migration or something like that
> potentially affect things?  And even if you did have hooks into every
> system call that mattered (keep in mind that relying on glibc is not
> enough, since an MPI application may not use glibc) would decoding them
> and figuring out what happened really be preferable to a single event
> type that tells you exactly what address range was affected? 

Yeah, virtual<->physical maps can change through swapping, page
migration, memory compaction, huge-page aggregation (the latter two not
yet being upstream).

Even mlock() doesn't pin virtual<->physical maps.
