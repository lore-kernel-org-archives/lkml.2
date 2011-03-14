Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab1CNWqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:46:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54524 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab1CNWqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:46:47 -0400
Date: Mon, 14 Mar 2011 18:46:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: ext4 deep stack with mark_page_dirty reclaim
Message-ID: <20110314224645.GA20348@infradead.org>
References: <alpine.LSU.2.00.1103141156190.3220@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1103141156190.3220@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Direct reclaim (in the cgroup variant) at it's work.  We had a couple of
flamewars on this before, but this trivial example with reclaim from
the most simple case (swap space) shows that we really should never
reclaim from memory allocation callers for stack usage reasons.

