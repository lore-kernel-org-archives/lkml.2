Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab1KUKL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:11:59 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39242
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755528Ab1KUKL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:11:57 -0500
Date: Mon, 21 Nov 2011 05:11:55 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Pekka Enberg <penberg@kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org
Subject: Re: [V2 PATCH] tmpfs: add fallocate support
Message-ID: <20111121101155.GC17887@infradead.org>
References: <1321612791-4764-1-git-send-email-amwang@redhat.com>
 <alpine.LSU.2.00.1111201300340.1264@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1111201300340.1264@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 20, 2011 at 01:22:10PM -0800, Hugh Dickins wrote:
> First question that springs to mind (to which I shall easily find
> an answer): is it actually acceptable for fallocate() to return
> -ENOSPC when it has already completed a part of the work?

No, it must undo all allocations if it returns ENOSPC.

