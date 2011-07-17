Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab1GQBEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 21:04:31 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45691 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab1GQBEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 21:04:30 -0400
Date: Sat, 16 Jul 2011 19:04:28 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Anton Blanchard <anton@samba.org>
Cc: npiggin@kernel.dk, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: vfsmount lock issues on very large ppc64 box
Message-ID: <20110717010427.GC5359@parisc-linux.org>
References: <20110717105027.53cc3ca4@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110717105027.53cc3ca4@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 10:50:27AM +1000, Anton Blanchard wrote:
> Looking closer, all of these calls are in pipefs and sockfs.
> Since we never mount either filesystem they never get a long term
> reference and we always end up in the very slow write brlock path
> that takes a lock for each online CPU.
> 
> Here is a quick hack that takes a long term reference on pipefs
> and sockfs which fixes the problem. Any thoughts on how we should
> fix it properly?

I know Tim and Andi have been looking into this ... I forget what their
fix was though.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
