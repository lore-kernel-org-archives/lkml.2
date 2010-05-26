Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320Ab0EZJzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 05:55:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932728Ab0EZJzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 05:55:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100526065129.GA3746@in.ibm.com>
References: <20100526065129.GA3746@in.ibm.com> <20100525083055.342788418@linux.vnet.ibm.com> <20100525091356.GB29003@in.ibm.com> <1274787559_8162@mail4.comsite.net>
To: prasad@linux.vnet.ibm.com
Cc: dhowells@redhat.com, Millton Miller <miltonm@bga.com>,
       Michael Neuling <mikey@neuling.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, shaggy@linux.vnet.ibm.com,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Gibson <dwg@au1.ibm.com>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 1/4] Allow arch-specific cleanup before breakpoint unregistration
Date: Wed, 26 May 2010 10:54:41 +0100
Message-ID: <4250.1274867681@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K.Prasad <prasad@linux.vnet.ibm.com> wrote:

> > My understanding is weak function definitions must appear in a different C
> > file than their call sites to work on some toolchains.
> > 
> 
> Atleast, there are quite a few precedents inside the Linux kernel for
> __weak functions being invoked from the file in which they are defined
> (arch_hwblk_init, arch_enable_nonboot_cpus_begin and hw_perf_disable to
> name a few).
> Moreover the online GCC docs haven't any such constraints mentioned.

I've seen problems in this area.  gcc sometimes inlines a weak function that's
in the same file as the call point.

David
