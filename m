Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1GRQix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:38:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:21758 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab1GRQit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:38:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,223,1309762800"; 
   d="scan'208";a="27206345"
Subject: Re: vfsmount lock issues on very large ppc64 box
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Anton Blanchard <anton@samba.org>, npiggin@kernel.dk,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20110717010427.GC5359@parisc-linux.org>
References: <20110717105027.53cc3ca4@kryten>
	 <20110717010427.GC5359@parisc-linux.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 09:41:16 -0700
Message-ID: <1311007276.2707.37.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2011-07-16 at 19:04 -0600, Matthew Wilcox wrote:
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
> 

I've sent out a trial patch a while ago on this problem, but didn't get
a response back. Nick or Al, can you take another look at this patch now
that other folks are also running into this issue?

http://marc.info/?l=linux-fsdevel&m=130273200502778&w=2

Thanks.

Tim

