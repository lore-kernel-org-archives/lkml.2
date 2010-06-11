Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab0FKHzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 03:55:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27303 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab0FKHzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 03:55:48 -0400
Date: Fri, 11 Jun 2010 00:55:28 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Christoph Hellwig <hch@lst.de>, Tao Ma <tao.ma@oracle.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH v4] ocfs2: Let ocfs2_setattr use new truncate sequence.
Message-ID: <20100611075528.GD23946@mail.oracle.com>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>,
	Tao Ma <tao.ma@oracle.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
References: <1276226869-11123-1-git-send-email-tao.ma@oracle.com>
 <20100611065635.GA19692@lst.de>
 <4C11E2BD.2020207@oracle.com>
 <20100611071945.GA20496@lst.de>
 <20100611075020.GC23946@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100611075020.GC23946@mail.oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4C11EBFA.008E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 12:50:20AM -0700, Joel Becker wrote:
> On Fri, Jun 11, 2010 at 09:19:45AM +0200, Christoph Hellwig wrote:
> > On Fri, Jun 11, 2010 at 03:16:13PM +0800, Tao Ma wrote:
> > > oh, that would be much work for ocfs2 to do from my perspective. So I 
> > > would really want to leave it as-is and I have add it to my to-do list.
> > 
> > Oh right, you start a new transaction there.  Sorry, ignore my request
> > and keep it as it is for now.  I don't think doing truncatate in separate
> > transactions actually is correct, though but that's no change with this
> > patch.
> 
> Christoph,
> 	You're missing the part where actual truncate (reduce i_size)
> sets i_size in ocfs2_truncate_file().  So this later code doesn't get
> triggered for the truncate case.  It exists for the extend case, where
> we extend the allocation in multiple clean transactions, then finally
> set i_size in a final transaction.

	Actually, ocfs2_extend_file() appears to handle it too.  I don't
think it used to - there were places that had issues with
commit_write()'s update of i_size, etc.  But that's ancient history.  I
wonder if Mark knows.

joel

-- 

Dort wo man Bücher verbrennt, verbrennt man am Ende auch Mensch.
(Wherever they burn books, they will also end up burning people.)
	- Heinrich Heine

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
