Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab0FPQb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:31:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37648 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932139Ab0FPQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:31:56 -0400
Subject: Re: [RFC PATCH 1/3] kbuild: Warn on selecting symbols with unmet
 direct dependencies
From: Catalin Marinas <catalin.marinas@arm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20100611133119.f372bbe1.randy.dunlap@oracle.com>
References: <20100611133119.f372bbe1.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 16 Jun 2010 17:31:38 +0100
Message-ID: <1276705898.22879.42.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jun 2010 16:31:39.0167 (UTC) FILETIME=[6544E2F0:01CB0D71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 21:31 +0100, Randy Dunlap wrote:
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
> Can these messages (on linux-next-20100611) be modified to include the
> kconfig symbol that is causing them?
> 
> warning: (IP_VS_PROTO_ESP && NET && NETFILTER && IP_VS ||
> IP_VS_PROTO_AH && NET && NETFILTER && IP_VS) selects
> IP_VS_PROTO_AH_ESP which has unmet direct dependencies (UNDEFINED)
> warning: (SCx200_GPIO && SCx200 || PC8736x_GPIO && X86) selects
> NSC_GPIO which has unmet direct dependencies (X86_32)
> 
> Ah!  It's the first symbol listed in each "phrase":

(sorry for the delay)

It is usually the first symbol though kbuild does some expression
reduction when calculating the dependencies and I can't guarantee that
it is always the case. It's probably for someone who understands kbuild
better then me to make the output easier to read.

-- 
Catalin

