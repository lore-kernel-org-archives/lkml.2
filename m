Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0LJDyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:54:08 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45255 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab0LJDyH (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 9 Dec 2010 22:54:07 -0500
Date: Thu, 9 Dec 2010 22:55:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH] Fix when booting Xen+Linux under QEMU.
Message-ID: <20101210035500.GA17525@dumpdata.com>
References: <1291928497-5599-1-git-send-email-konrad.wilk@oracle.com>
 <4D01462A.4010808@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D01462A.4010808@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think I'd prefer to:
> 
>    1. move to using all dynamic irqs, and use the core kernel irq
>       allocator (ie, resurrect IanC's patches)

That would make it easier, except that they don't work when you have DomU 
guest with Xen PCI front. Simply b/c the DomU guest has no idea of what GSI of
the host machine is. Hence the find_unbound_irq that starts from the top 
(nr_irqs) and goes down to GSI count (nr_irq_gsi).

Maybe we can stick it in the Xen PCIfronted/Xen PCI backend a mechanism (some 
key value) which will specify the host's nr_irq_gsi value. Then the DomU guest 
can set that and then use the core kernel irq allocator...
