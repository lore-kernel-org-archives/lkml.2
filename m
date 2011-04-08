Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab1DHSu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 14:50:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34409 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab1DHSu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 14:50:28 -0400
Date: Fri, 8 Apr 2011 11:50:13 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: djwong@us.ibm.com, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ext4: Calculate and verify inode checksums
Message-ID: <20110408185013.GB17677@noexit>
Mail-Followup-To: Sunil Mushran <sunil.mushran@oracle.com>,
	djwong@us.ibm.com, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com>
 <20110406224547.GT32706@tux1.beaverton.ibm.com>
 <4D9D0ADB.9010005@oracle.com>
 <20110407164006.GC24354@tux1.beaverton.ibm.com>
 <4D9DF01C.6050506@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9DF01C.6050506@oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 10:10:52AM -0700, Sunil Mushran wrote:
> On 04/07/2011 09:40 AM, Darrick J. Wong wrote:
> >That said, I haven't really quantified the performance impact of this naive
> >approach yet, so I wonder -- did you see a similar scenario with ocfs2, and
> >what kind of performance increase did you get by adapting the code to use the
> >jbd2 trigger?  If there's potentially a large increase, it would be interesting
> >to apply the same conversion to the group descriptor checksumming code too.
> 
> Joel Becker may remember the overhead. He wrote the patch. That said we have few
> differences. ocfs2 has larger (blocksized) inodes. Also, it computes ECC. The code
> is in fs/ocfs2/blockcheck.c.

	ocfs2 does the journal access/journal dirty cycle a lot more
than extN.  I think you'd want to generate your own numbers.

Joel


-- 

"Conservative, n.  A statesman who is enamoured of existing evils,
 as distinguished from the Liberal, who wishes to replace them
 with others."
	- Ambrose Bierce, The Devil's Dictionary

			http://www.jlbec.org/
			jlbec@evilplan.org
