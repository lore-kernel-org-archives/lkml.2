Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966753Ab2EPJwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 05:52:06 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57002 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752879Ab2EPJwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 05:52:04 -0400
Message-ID: <1337161920.2985.32.camel@dabdike.int.hansenpartnership.com>
Subject: Re: NVM Mapping API
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 16 May 2012 10:52:00 +0100
In-Reply-To: <20120515133450.GD22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 09:34 -0400, Matthew Wilcox wrote:
> There are a number of interesting non-volatile memory (NVM) technologies
> being developed.  Some of them promise DRAM-comparable latencies and
> bandwidths.  At Intel, we've been thinking about various ways to present
> those to software.  This is a first draft of an API that supports the
> operations we see as necessary.  Patches can follow easily enough once
> we've settled on an API.

If we start from first principles, does this mean it's usable as DRAM?
Meaning do we even need a non-memory API for it?  The only difference
would be that some pieces of our RAM become non-volatile.

Or is there some impediment (like durability, or degradation on rewrite)
which makes this unsuitable as a complete DRAM replacement?

> We think the appropriate way to present directly addressable NVM to
> in-kernel users is through a filesystem.  Different technologies may want
> to use different filesystems, or maybe some forms of directly addressable
> NVM will want to use the same filesystem as each other.

If it's actually DRAM, I'd present it as DRAM and figure out how to
label the non volatile property instead.

Alternatively, if it's not really DRAM, I think the UNIX file
abstraction makes sense (it's a piece of memory presented as something
like a filehandle with open, close, seek, read, write and mmap), but
it's less clear that it should be an actual file system.  The reason is
that to present a VFS interface, you have to already have fixed the
format of the actual filesystem on the memory because we can't nest
filesystems (well, not without doing artificial loopbacks).  Again, this
might make sense if there's some architectural reason why the flash
region has to have a specific layout, but your post doesn't shed any
light on this.

James


