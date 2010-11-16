Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab0KPUjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:39:14 -0500
Received: from THUNK.ORG ([69.25.196.29]:35917 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648Ab0KPUjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:39:07 -0500
Date: Tue, 16 Nov 2010 15:38:54 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4 Fix setting random pages PageUptodate
Message-ID: <20101116203854.GA1568@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@linux.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <20101110152519.GA1626@arch.trippelsdorf.de>
 <20101110154057.GA2191@arch.trippelsdorf.de>
 <alpine.DEB.2.00.1011101534370.30164@router.home>
 <20101112122003.GA1572@arch.trippelsdorf.de>
 <20101115123846.GA30047@arch.trippelsdorf.de>
 <20101115195439.GA1569@arch.trippelsdorf.de>
 <AANLkTikWaADzUrqKhZ9gviW8sk8mPjC9kKFJyitvzQmx@mail.gmail.com>
 <20101116111339.GA1544@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116111339.GA1544@arch.trippelsdorf.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 12:13:39PM +0100, Markus Trippelsdorf wrote:
> ext4_end_bio calls put_page and kmem_cache_free before calling
> SetPageUpdate(). This can result in setting the PageUptodate bit on
> random pages and causes the following BUG:

Oops.   Thanks muchly to you and to Hugh for discovering this.

I've added this to the ext4 patch queue and will be pushing to Linus
this week, for -rc3.

					- Ted
