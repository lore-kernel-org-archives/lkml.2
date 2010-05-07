Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab0EGPpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:45:39 -0400
Received: from exhub016-2.exch016.msoutlookonline.net ([207.5.72.164]:10460
	"EHLO EXHUB016-2.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756131Ab0EGPph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:45:37 -0400
Message-ID: <4BE4359E.9020400@cfl.rr.com>
Date: Fri, 7 May 2010 11:45:34 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unified page and buffer cache?
References: <4BCC7C05.8000803@cfl.rr.com> <4BE417CB.7000806@cfl.rr.com> <20100507135329.GA17259@parisc-linux.org>
In-Reply-To: <20100507135329.GA17259@parisc-linux.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/2010 9:53 AM, Matthew Wilcox wrote:
> The problem you're seeing is aliasing in the page cache, not a failed
> unification of the buffer and page caches.  Pages are addressed by
> (mapping, offset).  Each inode generally has its own mapping.  Depending
> on the file system, directories may be addressed by their own inode's
> mapping, or by the block device's mapping.

If there are two mappings that don't know about each other, then the
caches don't seem very unified to me.  If I write to the file and that
data sits in the mapping for the inode, then I read the corresponding
blocks though the block device, and it has a different mapping, then I
read the old data off the disk instead of the new data in the cache.  I
thought that this exact problem had been fixed long ago.

> Resolving aliasing would be horribly expensive, so it's unlikely to
> happen.

Back to the drawing board I guess.  Maybe ext could be fixed to use an
inode mapping for directories instead of relying on the block device
mapping, then I could readahead() the directory instead of having to go
to the block device at all.
