Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1GRIRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 04:17:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45491 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab1GRIRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 04:17:20 -0400
Subject: Re: vfsmount lock issues on very large ppc64 box
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Anton Blanchard <anton@samba.org>,
        npiggin@kernel.dk, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>
In-Reply-To: <20110717084630.GC8006@one.firstfloor.org>
References: <20110717105027.53cc3ca4@kryten>
	 <20110717010427.GC5359@parisc-linux.org>
	 <20110717084630.GC8006@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 10:17:08 +0200
Message-ID: <1310977028.5756.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 17 juillet 2011 à 10:46 +0200, Andi Kleen a écrit :
> On Sat, Jul 16, 2011 at 07:04:28PM -0600, Matthew Wilcox wrote:
> > On Sun, Jul 17, 2011 at 10:50:27AM +1000, Anton Blanchard wrote:
> > > Looking closer, all of these calls are in pipefs and sockfs.
> > > Since we never mount either filesystem they never get a long term
> > > reference and we always end up in the very slow write brlock path
> > > that takes a lock for each online CPU.
> > > 
> > > Here is a quick hack that takes a long term reference on pipefs
> > > and sockfs which fixes the problem. Any thoughts on how we should
> > > fix it properly?
> > 
> > I know Tim and Andi have been looking into this ... I forget what their
> > fix was though.
> 
> Tim posted a patch, but it wasn't applied for unknown reasons.
> 
> https://lkml.org/lkml/2011/4/13/561
> 

Could Tim respin his patch then ?

This problem hits even a two sockets machine.



