Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab1COA20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 20:28:26 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:52932 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab1COA2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 20:28:25 -0400
Date: Mon, 14 Mar 2011 20:27:59 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: perf: kernel memory leak when inherit enabled
In-Reply-To: <20110314223224.GD9388@ghostprotocols.net>
Message-ID: <alpine.DEB.2.00.1103142026350.16076@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1103111745070.15818@cl320.eecs.utk.edu> <alpine.DEB.2.00.1103141824190.13179@cl320.eecs.utk.edu> <20110314223224.GD9388@ghostprotocols.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, Arnaldo Carvalho de Melo wrote:

> Em Mon, Mar 14, 2011 at 06:27:19PM -0400, Vince Weaver escreveu:
> > On Fri, 11 Mar 2011, Vince Weaver wrote:
> > > 
> > > While trying to use perf events with inherit enabled to profile some 
> > > multi-threaded BLAS routines (using PAPI) I ended up out-of-memorying my 
> > > machine.  It turns out you can quickly leak gigabytes of kernel memory
> > > that isn't freed when the process exits.
> > 
> > I've bisected this.  There's a whole day I'll never see again. binutils 
> > 2.21 and gcc-4.5 for the lose :(
> > 
> > Anyway this memory leak with inherit was introduced in 
> >   4fd38e4595e
> 
> 
> commit 4fd38e4595e2f6c9d27732c042a0e16b2753049c
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Thu May 6 17:31:38 2010 +0200
> 
>     perf: Fix exit() vs PERF_FORMAT_GROUP

This changeset was reverted already in 
e3174cfd2a1e28fff774681f00a0eef3d31da970
yet somehow that didn't fix the inherit mem-leak.

Vince
vweaver1@eecs.utk.edu
