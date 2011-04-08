Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab1DHPO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:14:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51787 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab1DHPO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:14:56 -0400
Date: Fri, 8 Apr 2011 11:14:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steve Rago <sar@nec-labs.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Allow O_SYNC to be set by fcntl(F_SETFL)
Message-ID: <20110408151454.GA1444@infradead.org>
References: <4D6824A4.6030009@nec-labs.com>
 <20110407143719.4044c00d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110407143719.4044c00d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I actually prototypes this patch independetly a while ago, and in
addition to the data writeout when removing O_SYNC there are the
following caveats:

 - O_SYNC is not actually one flag, but two: O_DSYNC and __O_SYNC.
   setfl() needs to make sure __O_SYNC cannot be in f_flags without
   O_DSYNC also beeing present.
 - we need to audit all filesystems that they don't do stupid things
   when the O_SYNC flags appear or disappear during a write, that
   is make sure it is checked in just one place.  The generic write
   code is fine in that respect, but I didn't go through all filesystems
   to verify it yet.

