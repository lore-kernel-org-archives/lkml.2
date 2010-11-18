Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab0KRQCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:02:36 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50532 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759303Ab0KRQCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:02:35 -0500
Subject: Re: [PATCH] writeback: prevent bandwidth calculation overflow
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, "Li, Shaohua" <shaohua.li@intel.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101118154408.GA18582@localhost>
References: <20101118065725.GB8458@localhost> <4CE537BE.6090103@redhat.com>
	 <20101118154408.GA18582@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Nov 2010 17:02:01 +0100
Message-ID: <1290096121.2109.1525.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 23:44 +0800, Wu Fengguang wrote:
> +               pause = HZ * pages_dirtied / (bw + 1);

Shouldn't that be using something like div64_u64 ?
