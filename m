Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab0F2CWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 22:22:36 -0400
Received: from lo.gmane.org ([80.91.229.12]:41232 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab0F2CWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 22:22:35 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@queued.net>
Subject: Re: [RFC PATCH 1/3] kbuild: Warn on selecting symbols with unmet
 direct dependencies
Date: Mon, 28 Jun 2010 22:22:21 -0400
Message-ID: <20100628222221.620987a9@debian>
References: <20100608162046.21870.5615.stgit@e102109-lin.cambridge.arm.com>
	<20100608162556.21870.5952.stgit@e102109-lin.cambridge.arm.com>
	<20100611133119.f372bbe1.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: dhcp-18-111-83-38.dyn.mit.edu
In-Reply-To: <20100611133119.f372bbe1.randy.dunlap@oracle.com>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Cc: linux-geode@bombadil.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 13:31:19 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Tue, 08 Jun 2010 17:25:57 +0100 Catalin Marinas wrote:
> 
> > The "select" statement in Kconfig files allows the enabling of options
> > even if they have unmet direct dependencies (i.e. "depends on" expands
> > to "no"). Currently, the "depends on" clauses are used in calculating
> > the visibility but they do not affect the reverse dependencies in any
> > way.
> > 
> > The patch introduces additional tracking of the "depends on" statements
> > and prints a warning on selecting an option if its direct dependencies
> > are not met.
> 
> 
> Hi Catalin,
> 
> Can these messages (on linux-next-20100611) be modified to include the
> kconfig symbol that is causing them?
> 
> warning: (IP_VS_PROTO_ESP && NET && NETFILTER && IP_VS || IP_VS_PROTO_AH && NET && NETFILTER && IP_VS) selects IP_VS_PROTO_AH_ESP which has unmet direct dependencies (UNDEFINED)
> warning: (SCx200_GPIO && SCx200 || PC8736x_GPIO && X86) selects NSC_GPIO which has unmet direct dependencies (X86_32)
> 
> Ah!  It's the first symbol listed in each "phrase":
> 
> SCx200_GPIO and PC8736x_GPIO both have this problem.
> (I haven't looked at IP_VS yet).

It's unclear why NSC_GPIO depends upon X86_32 (davej sent the patch,
699352c30da8525a).  While geode stuff will probably only ever exist on x86,
there's nothing in the driver that's X86_32-specific.


> 
> Jordan, is GEODE always 32-bit, so that some of these dependencies could be
> cleaned up by using X86_32?

Sadly, I don't think Jordan tracks this list any more.



