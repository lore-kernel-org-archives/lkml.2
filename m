Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab2EPEqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 00:46:50 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:64600 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2EPEqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 00:46:48 -0400
Date: Wed, 16 May 2012 06:46:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, mmarek@suse.cz, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the kbuild tree with the
	sparc-next tree
Message-ID: <20120516044646.GA340@merkur.ravnborg.org>
References: <20120516134430.14f8e43c6f75604410dae815@canb.auug.org.au> <20120515.235747.716576574995746023.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515.235747.716576574995746023.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 11:57:47PM -0400, David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 16 May 2012 13:44:30 +1000
> 
> > Today's linux-next merge of the kbuild tree got a conflict in
> > arch/sparc/boot/Makefile between commit 51f19cfa76d7 ("sparc32: drop
> > build time btfixup patching") from the sparc-next tree and commit
> > 95698570510b ("kbuild: refactor final link of sparc32") from the kbuild
> > tree.
> > 
> > I have no idea, so I used the version from the sparc-next tree.
> > 
> > Sam, can you have a look and work this out, please?
> 
> As Sam states in:
> 
> http://patchwork.ozlabs.org/patch/159094/
> 
> 	This patch will conflict badly with a patch in kbuild-next.
> 
> 	The fix is simple - drop all changes from kbuild-next.
> 
> :-)
The above comment is true for both arch/sparc/Makefile and
arch/sparc/bot/Makefile.

sparc-next will also conflict with net-next.

net-next add the following line to arch/sparc/Makefile:
+core-y                 += arch/sparc/net/

The fix is to add this line to the newly introduced
arch/sparc/Kbuild file like this:

obj-y += net/

Sorry for these conflicts but we have been busy in sparc land
this round.

	Sam
