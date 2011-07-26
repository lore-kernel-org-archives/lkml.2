Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1GZPWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:22:01 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58306 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab1GZPVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:21:54 -0400
Subject: Re: [PATCH] xfs: Fix wrong return value of xfs_file_aio_write
From: Alex Elder <aelder@sgi.com>
Reply-To: <aelder@sgi.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>,
        <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <jack@suse.cz>, <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, <xfs@oss.sgi.com>
In-Reply-To: <20110724120330.GC1626@x4.trippels.de>
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
	 <20110723180942.GA1616@x4.trippels.de> <4E2B2E88.8080006@redhat.com>
	 <20110723203824.GB1652@x4.trippels.de>
	 <20110723220212.GA1648@x4.trippels.de>
	 <20110724111625.GA12658@infradead.org>
	 <20110724115420.GA1626@x4.trippels.de>
	 <20110724115826.GB1626@x4.trippels.de>
	 <20110724120330.GC1626@x4.trippels.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jul 2011 10:21:48 -0500
Message-ID: <1311693708.2890.5.camel@doink>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.232.50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-24 at 14:03 +0200, Markus Trippelsdorf wrote:
> The fsync prototype change commit 02c24a82187d accidentally overwrote
> the ssize_t return value of xfs_file_aio_write with 0 for SYNC type
> writes. Fix this by checking if an error occured when calling
> xfs_file_fsync and only change the return value in this case.
> In addition xfs_file_fsync actually returns a normal negative error, so
> fix this, too.
> 
> Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Christoph Hellwig <hch@lst.de>

Finally looking at this I noticed the same thing Christoph
did; thanks for fixing both.  Your change got committed
yesterday via Al Viro's VFS tree.

					-Alex

