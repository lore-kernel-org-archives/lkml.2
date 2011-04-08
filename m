Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab1DHVIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 17:08:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36292 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777Ab1DHVIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 17:08:54 -0400
Date: Fri, 8 Apr 2011 17:08:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steve Rago <sar@nec-labs.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Allow O_SYNC to be set by fcntl(F_SETFL)
Message-ID: <20110408210853.GA12590@infradead.org>
References: <4D6824A4.6030009@nec-labs.com>
 <20110407143719.4044c00d.akpm@linux-foundation.org>
 <4D9F4844.7090908@nec-labs.com>
 <20110408105602.bb8f1b49.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408105602.bb8f1b49.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 10:56:02AM -0700, Andrew Morton wrote:
> Because it's inconsistent.  An O_SYNC fd never has outstanding writeout. 
> Except for in this one new and special time window between a setfl()
> and the next write().

It might actually have outstanding writes for as long as it eventually
takes the writeback code to push them out.  O_SYNC only does a range
writeout for the area that was written.

