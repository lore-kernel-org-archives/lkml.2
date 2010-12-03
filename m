Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab0LCHJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 02:09:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33612 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab0LCHJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 02:09:53 -0500
Date: Fri, 3 Dec 2010 02:09:50 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: Set barrier=0 when block device does not advertise
 flush support
Message-ID: <20101203070950.GA19071@infradead.org>
References: <20101203001659.GI18195@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203001659.GI18195@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 04:16:59PM -0800, Darrick J. Wong wrote:
> If the user tries to enable write flushes with "barrier=1" and the underlying
> block device does not support flushes, print a message and set barrier=0.

That doesn't make any sense at all with the ne wFLUSH+FUA code, which is
designed to make the cache flushing entirely transparanent.  Basically
with the new code the barrier option should become a no-op and always
enabled.

