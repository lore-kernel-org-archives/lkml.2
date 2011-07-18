Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1GRPk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 11:40:28 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56400
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab1GRPk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 11:40:27 -0400
Date: Mon, 18 Jul 2011 11:40:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
        Anton Blanchard <anton@samba.org>, npiggin@kernel.dk,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: vfsmount lock issues on very large ppc64 box
Message-ID: <20110718154008.GA29593@infradead.org>
References: <20110717105027.53cc3ca4@kryten>
 <20110717010427.GC5359@parisc-linux.org>
 <20110717084630.GC8006@one.firstfloor.org>
 <1310977028.5756.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310977028.5756.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 10:17:08AM +0200, Eric Dumazet wrote:
> > Tim posted a patch, but it wasn't applied for unknown reasons.
> > 
> > https://lkml.org/lkml/2011/4/13/561
> > 
> 
> Could Tim respin his patch then ?

Btw, it seems like most kern_mount users want this and he's still
missing some like devtmpfs, sysfs or ipc.  What about splitting
kern_mount into a variant that gets a long-term reference for these
callers, and one that doesn't for afs/cifs/nfs automounts?

