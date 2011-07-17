Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab1GQIqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 04:46:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49456 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab1GQIqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 04:46:34 -0400
Date: Sun, 17 Jul 2011 10:46:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Anton Blanchard <anton@samba.org>, npiggin@kernel.dk,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: vfsmount lock issues on very large ppc64 box
Message-ID: <20110717084630.GC8006@one.firstfloor.org>
References: <20110717105027.53cc3ca4@kryten> <20110717010427.GC5359@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110717010427.GC5359@parisc-linux.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 07:04:28PM -0600, Matthew Wilcox wrote:
> On Sun, Jul 17, 2011 at 10:50:27AM +1000, Anton Blanchard wrote:
> > Looking closer, all of these calls are in pipefs and sockfs.
> > Since we never mount either filesystem they never get a long term
> > reference and we always end up in the very slow write brlock path
> > that takes a lock for each online CPU.
> > 
> > Here is a quick hack that takes a long term reference on pipefs
> > and sockfs which fixes the problem. Any thoughts on how we should
> > fix it properly?
> 
> I know Tim and Andi have been looking into this ... I forget what their
> fix was though.

Tim posted a patch, but it wasn't applied for unknown reasons.

https://lkml.org/lkml/2011/4/13/561

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
