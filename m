Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0FGVj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:39:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:48556 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0FGVj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:39:57 -0400
Subject: Re: [git pull] drm fixes
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Dave Airlie <airlied@linux.ie>,
       dri-devel@lists.freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1006071409320.4506@i5.linux-foundation.org>
References: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie>
	 <alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org>
	 <20100607182640.GL31073@ZenIV.linux.org.uk>
	 <alpine.LFD.2.00.1006071146451.3515@i5.linux-foundation.org>
	 <1275939165.17903.5100.camel@macbook.infradead.org>
	 <alpine.LFD.2.00.1006071409320.4506@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 22:39:28 +0100
Message-ID: <1275946768.17903.5126.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-6.fc13) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 14:17 -0700, Linus Torvalds wrote:
> and that changelog doesn't really explain it either ("fix leak"? Ok, I can 
> see the iput() fixing the leak - but you also did that jffs2_clear_inode() 
> change, and that has no explanation what-so-ever.

jffs2_clear_inode() is the file system's ->clear_inode method, so it
gets called from the VFS when the inode is destroyed, after iput().

I suppose that ought to have been a clue, right from the very beginning,
that we should never have been calling it directly on our error paths.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

