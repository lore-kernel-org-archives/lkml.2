Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab2C1R5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 13:57:09 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:53335 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758165Ab2C1R5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 13:57:07 -0400
Date: Wed, 28 Mar 2012 19:57:01 +0200
From: Borislav Petkov <bp@amd64.org>
To: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] tools: Add a toplevel Makefile
Message-ID: <20120328175701.GB13426@aftab>
References: <1332513788-9726-1-git-send-email-bp@amd64.org>
 <20120324074412.GE20145@gmail.com>
 <20120326122632.GC32090@aftab>
 <20120326151432.GA8527@gmail.com>
 <20120326154132.GJ32090@aftab>
 <20120328072528.GA22885@gmail.com>
 <20120328095125.GA16369@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328095125.GA16369@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 11:51:25AM +0200, Borislav Petkov wrote:
> I'm currently thinking I want to give the make tools/{perf,help,...}
> approach a try because it is clear that it is a subdir of the kernel src
> tree and it probably could support all the targets we thought about.
> 
> Let me play around with it a bit...

Yeah, nasty. I've almost got it to build a tool when doing

$ make tools/<toolname>

but it fails on all the targets which have implicit build rules. (It
seems to build perf fine though because perf Makefile doesn't have
implicit rules for %.c -> %.o etc). And I can see that implicit rules
are being cleared in the toplevel kernel Makefile so that they don't
kick in.

At this moment, I'm open for hints from the kbuild people, if we use the
toplevel Makefile to build tools/, should all the tools' Makefiles have
explicit rules or ...? Any suggestions are appreciated.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
