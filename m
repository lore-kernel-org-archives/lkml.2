Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab1CXWW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:22:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51010 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab1CXWW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:22:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=V3nt/C3MZxVzn7v7yBvDHsjlfRGPH3Eiy7+cEPoZxRb+aOECH0t0eb2rLfXZWY61/E
         TJml73srCe1XvMK/w1Yw==
Date: Thu, 24 Mar 2011 15:22:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Marc Kleine-Budde <mkl@pengutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: multiple definition of `show_mem'
In-Reply-To: <4D8B6140.4020300@pengutronix.de>
Message-ID: <alpine.DEB.2.00.1103241522230.26730@chino.kir.corp.google.com>
References: <4D8B6140.4020300@pengutronix.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Marc Kleine-Budde wrote:

> Hello,
> 
> current mainline (v2.6.38-7210-gb81a618) on ARM/mxs has the following build failure:
> 
> > lib/lib.a(show_mem.o): In function `show_mem':
> > .../linux-2.6/lib/show_mem.c:67: multiple definition of `show_mem'
> > arch/arm/mm/built-in.o:.../linux-2.6/arch/arm/mm/init.c:82: first defined here
> > make: *** [vmlinux.o] Error 1
> 
> After reverting these patches the kernel compiles...
> 
> cbf978bfb12d7deca97d7333f65eda0381a072de oom: suppress nodes that are not allowed from meminfo on page alloc failure
> 29423e77c06cee7d4e335ef4a7cbd949da978c91 oom: suppress show_mem() for many nodes in irq context on page alloc failure
> ddd588b5dd55f14320379961e47683db4e4c1d90 oom: suppress nodes that are not allowed from meminfo on oom kill
> 
> No time to boot the kernel, though.
> 

Sorry about that, Marc.  I have a patch at

	http://marc.info/?l=linux-kernel&m=130100511521954

which should fix the issue for you (and I tested it with my arm cross 
compiler).
