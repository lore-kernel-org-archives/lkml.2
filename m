Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab0FKHTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 03:19:54 -0400
Received: from verein.lst.de ([213.95.11.210]:33590 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab0FKHTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 03:19:53 -0400
Date: Fri, 11 Jun 2010 09:19:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tao Ma <tao.ma@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joel Becker <joel.becker@oracle.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH v4] ocfs2: Let ocfs2_setattr use new truncate sequence.
Message-ID: <20100611071945.GA20496@lst.de>
References: <1276226869-11123-1-git-send-email-tao.ma@oracle.com> <20100611065635.GA19692@lst.de> <4C11E2BD.2020207@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C11E2BD.2020207@oracle.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 03:16:13PM +0800, Tao Ma wrote:
> Hi Christoph,
> 
> On 06/11/2010 02:56 PM, Christoph Hellwig wrote:
> >This looks correct, but still has the second if ATTR_SIZE block that
> >I commented on last time.  I'd really prefer if the filesystems could
> >move the truncate handling into a single conditional to simplify
> >auditing for it and possibly splitting it out into a separate method
> >later.
> oh, that would be much work for ocfs2 to do from my perspective. So I 
> would really want to leave it as-is and I have add it to my to-do list.

Oh right, you start a new transaction there.  Sorry, ignore my request
and keep it as it is for now.  I don't think doing truncatate in separate
transactions actually is correct, though but that's no change with this
patch.
