Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1GSDgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 23:36:11 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53547
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230Ab1GSDgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 23:36:10 -0400
Date: Mon, 18 Jul 2011 23:36:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC][PATCH] Anonymous shared memory (ashmem) subsystem
Message-ID: <20110719033602.GA4867@infradead.org>
References: <1311015274-28650-1-git-send-email-john.stultz@linaro.org>
 <20110719021947.GA16986@infradead.org>
 <CAF_S4t_oOwsuPJdMXv+wPVhzecUag=TOWj1-KtFJqYUZOCBbog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF_S4t_oOwsuPJdMXv+wPVhzecUag=TOWj1-KtFJqYUZOCBbog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 11:32:42PM -0400, Bryan Donlan wrote:
> The pinning stuff seems like a reasonable idea to me, but why should
> it be limited to ashmem using a private ioctl? If it were a proper
> syscall, I could see automatic discarding being useful in on-disk
> filesystems as well, for managing persistent caches.

Exactly.

> But yes, tmpfs
> already solved the problem of getting a shared-memory file descriptor
> - just open a random-name file in tmpfs, unlink it, and start passing
> it around.

Indeed.  And as mentioned before using /dev/zero as the file will
get you a pre-unlinked tmpfs fd without any races, and without the
need of actually mounting shmem into any namespace.
