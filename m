Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1BCCcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 21:32:10 -0500
Received: from hiauly1.hia.nrc.ca ([132.246.10.84]:4387 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab1BCCcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 21:32:08 -0500
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Feb 2011 21:32:08 EST
Subject: Re: 2.6.38-rc3 regression on parisc: segfaults
To: mroos@linux.ee (Meelis Roos)
Date: Wed, 2 Feb 2011 21:24:20 -0500 (EST)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.SOC.1.00.1102012342200.25944@math.ut.ee> from "Meelis Roos" at Feb 2, 2011 00:00:13 am
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20110203022420.A73F54E7B@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have been testing devel kernels on SMP L1000 successfully until 
> 2.6.38-rc2-00324-g70d1f36 included. The testing means booting the new 
> kernel and running aptitude to update to current debian unstable.
> 
> Now I tried 2.6.38-rc3 and got a crash from aptitude on 2 out of 2 
> tries. Maybe aptitude was broken inbetween but it looks like a kernel 
> bug. Retried 2.6.38-rc2-00324-g70d1f36 and that seemed to work fine so 
> it's more likely a kernel problem.

If aptitude fails consistently, it should be possible to debug or
isolate to a particular kernel change.  Usually, SMP segvs don't
provide much information as to the cause of the problem.  strace
output and a gdb backtrace would be useful.

I have seen improved SMP stability building with GCC 4.5.3 (try a
recent snap).  This fixes an asm/branch problem.  It seems like James'
flush patch hasn't been pulled.

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
