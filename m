Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0DONzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 09:55:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41627 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753486Ab0DONzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 09:55:15 -0400
Date: Thu, 15 Apr 2010 14:59:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michal Svoboda <michal.svoboda@agents.felk.cvut.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kconfig: Make config Filter access to /dev/mem default
 y
Message-ID: <20100415145940.243723b7@lxorguk.ukuu.org.uk>
In-Reply-To: <20100415134152.GK21894@myhost.felk.cvut.cz>
References: <20100413025228.GC10860@localhost.localdomain>
	<m2v7b6bb4a51004142312ze69796ak87d4ee65f6dd5529@mail.gmail.com>
	<20100415063626.GG21894@myhost.felk.cvut.cz>
	<alpine.LRH.2.00.1004151233010.28179@twin.jikos.cz>
	<20100415134152.GK21894@myhost.felk.cvut.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010 15:41:53 +0200
Michal Svoboda <michal.svoboda@agents.felk.cvut.cz> wrote:

> Jiri Kosina wrote:
> > Access to /dev/mem being filtered in PAT obviously applies only to x86. 
> > 
> > Architectures which don't do such filtering in their respective 
> > phys_mem_access_prot_allowed() still need this option.
> 
> So why not use it for all archs uniformly? Is PAT filtering better in
> some ways? 

PAT is an x86 specific hardware feature. The x86 processors can set per
page caching properties as with some other CPU designs. In the x86 case
all references to the page must have the same cache settings so the PAT
implementation has to filter /dev/mem access to avoid machine check
errors.

It's not implemented as a security feature, its a side effect of the
hardware requirements on that CPU range.

Alan
