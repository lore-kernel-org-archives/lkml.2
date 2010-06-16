Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab0FPKVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:21:06 -0400
Received: from verein.lst.de ([213.95.11.210]:34651 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab0FPKVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:21:04 -0400
Date: Wed, 16 Jun 2010 12:20:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-32: remove CONFIG_4KSTACKS
Message-ID: <20100616102051.GA7731@lst.de>
References: <20100616091621.GA4486@lst.de> <20100616112136.42ab08ef@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616112136.42ab08ef@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 11:21:36AM +0100, Alan Cox wrote:
> On Wed, 16 Jun 2010 11:16:21 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > These days 4 kilobytes of stack just aren't enough for reliably operation,
> > and people using lots of threads have long switched to x86-64, so remove the
> > CONFIG_4KSTACKS option.
> 
> It's very useful for things like debugging and because of the split
> kernel/irq stacks.

Ingo just ACKed my previous patch to make irq stacks unconditional.

> It also seems to be quite adequate for most
> configurations.

See the direct reclaim flamewar.  Currently we can end up in ->writepage
from af_unix poll code with over 3k stack alreay used.  It's certainly
not anywhere near enough.

> Perhaps XFS should select 8K stack instead ?

or rather !CONFIG_INSANE.  I don't care too much.  No one sane should
ever enable it anymore, but Ingo asked me to send a patch to remove it.
