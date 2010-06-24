Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0FXH4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:56:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:47528 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab0FXH4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:56:09 -0400
Subject: Re: [patch 14/52] fs: dcache scale subdirs
From: Peter Zijlstra <peterz@infradead.org>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
In-Reply-To: <20100624030727.818410048@suse.de>
References: <20100624030212.676457061@suse.de>
	 <20100624030727.818410048@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 09:56:01 +0200
Message-ID: <1277366161.1875.888.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 13:02 +1000, npiggin@suse.de wrote:
> plain text document attachment (fs-dcache-scale-d_subdirs.patch)
> Protect d_subdirs and d_child with d_lock, except in filesystems that aren't
> using dcache_lock for these anyway (eg. using i_mutex).
> 
> XXX: probably don't need parent lock in inotify (because child lock
> should stabilize parent). Also, possibly some filesystems don't need so
> much locking (eg. of child dentry when modifying d_child, so long as
> parent is locked)... but be on the safe side. Hmm, maybe we should just
> say d_child list is protected by d_parent->d_lock. d_parent could remain
> protected with d_lock.
> 
> XXX: leave dcache_lock in there until remove dcache_lock patch

This still suffers the problem John found, right?
