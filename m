Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab0GDQ4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 12:56:41 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33881 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851Ab0GDQ4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 12:56:40 -0400
Date: Sun, 4 Jul 2010 10:56:38 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH -v2] Move list types from <linux/list.h> to
	<linux/types.h>.
Message-ID: <20100704165638.GE5842@parisc-linux.org>
References: <201007041242.o64CggfV012188@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007041242.o64CggfV012188@farm-0002.internal.tilera.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 01:41:14PM -0400, Chris Metcalf wrote:
> This allows a list_head (or hlist_head, etc.) to be used from places
> that used to be impractical, in particular <asm/processor.h>, which
> used to cause include file recursion: <linux/list.h> includes
> <linux/prefetch.h>, which always includes <asm/processor.h> for the
> prefetch macros, as well as <asm/system.h>, which often includes
> <asm/processor.h> directly or indirectly.
> 
> This avoids a lot of painful workaround hackery on the tile
> architecture, where we use a list_head in the thread_struct to chain
> together tasks that are activated on a particular hardwall.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
