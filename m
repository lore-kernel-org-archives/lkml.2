Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857Ab0FKUdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:33:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34026 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab0FKUdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:33:03 -0400
Date: Fri, 11 Jun 2010 13:31:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>, linux-geode@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH 1/3] kbuild: Warn on selecting symbols with unmet
 direct dependencies
Message-Id: <20100611133119.f372bbe1.randy.dunlap@oracle.com>
In-Reply-To: <20100608162556.21870.5952.stgit@e102109-lin.cambridge.arm.com>
References: <20100608162046.21870.5615.stgit@e102109-lin.cambridge.arm.com>
	<20100608162556.21870.5952.stgit@e102109-lin.cambridge.arm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C129D50.00ED:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jun 2010 17:25:57 +0100 Catalin Marinas wrote:

> The "select" statement in Kconfig files allows the enabling of options
> even if they have unmet direct dependencies (i.e. "depends on" expands
> to "no"). Currently, the "depends on" clauses are used in calculating
> the visibility but they do not affect the reverse dependencies in any
> way.
> 
> The patch introduces additional tracking of the "depends on" statements
> and prints a warning on selecting an option if its direct dependencies
> are not met.


Hi Catalin,

Can these messages (on linux-next-20100611) be modified to include the
kconfig symbol that is causing them?

warning: (IP_VS_PROTO_ESP && NET && NETFILTER && IP_VS || IP_VS_PROTO_AH && NET && NETFILTER && IP_VS) selects IP_VS_PROTO_AH_ESP which has unmet direct dependencies (UNDEFINED)
warning: (SCx200_GPIO && SCx200 || PC8736x_GPIO && X86) selects NSC_GPIO which has unmet direct dependencies (X86_32)

Ah!  It's the first symbol listed in each "phrase":

SCx200_GPIO and PC8736x_GPIO both have this problem.
(I haven't looked at IP_VS yet).

Jordan, is GEODE always 32-bit, so that some of these dependencies could be
cleaned up by using X86_32?

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
