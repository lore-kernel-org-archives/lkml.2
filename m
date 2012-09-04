Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab2IDOP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:15:56 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38303 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab2IDOPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:15:55 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 10:15:55 EDT
Date: Tue, 4 Sep 2012 08:09:08 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Hellwig <hch@infradead.org>
Cc: Li Wang <liwang@nudt.edu.cn>, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] VFS: File System Mount Wide O_DIRECT Support
Message-ID: <20120904140908.GC21160@parisc-linux.org>
References: <000001cd8a86$89df83b0$9d9e8b10$@edu.cn> <20120904105714.GA31020@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904105714.GA31020@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 06:57:14AM -0400, Christoph Hellwig wrote:
> On Tue, Sep 04, 2012 at 06:17:47PM +0800, Li Wang wrote:
> > For file system created on file-backed loop device, there will be two-levels of 
> > page cache present, which typically doubles the memory consumption. 
> 
> And the right fix is to not use buffer I/O on the backing file instead
> of hacks like this.

That was my initial reaction too, but for the case of two VMs operating on
the same device, it's better for it to be cached once in the hype-rvisor
than twice in the VMs.  Is that a common case worth optimising for?
Probably not ...

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
