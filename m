Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0JAUxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:53:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:45010 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab0JAUxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:53:38 -0400
Subject: Re: Odd NFS related SIGBUS (& possible fix)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Nick Piggin <npiggin@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org
In-Reply-To: <1285956768.30373.39.camel@heimdal.trondhjem.org>
References: <1285734825.14081.87.camel@pasglop>
	 <1285956768.30373.39.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Oct 2010 06:53:27 +1000
Message-ID: <1285966407.2463.145.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 14:12 -0400, Trond Myklebust wrote:
> 
> However, it looks to me as if the right thing to do when the
> page->mapping has changed would be to do the same thing as
> block_page_mkwrite(), and just return VM_FAULT_NOPAGE so that the VM
> can
> retry the fault.
> IMO: We should only SIGBUS if the calls to nfs_flush_incompatible()
> and/or nfs_updatepage() fail.

Well, other filesystems seem to think that if the mapping -changed-,
SIGBUS is a good idea... But they don't have to deal with invalidations
wiping mappings in the background.

So that's why I was thinking about singling out the "mapping became
NULL" case and keep the SIGBUS for when the mapping became something
else... but that's your call really :-)

Cheers,
Ben.

