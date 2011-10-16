Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab1JPAlm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 20:41:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19275 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab1JPAll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 20:41:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=TNDtMOTIILiHUlkQxgYmjDXUbVhdRsC0tIBmD5f6Y5RGMFfIO7F1xtXW5RwsZTTsC
	s/07ul8tc3PLLHw/FCV7g==
Date: Sat, 15 Oct 2011 17:41:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>
cc: Andi Kleen <andi@firstfloor.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [patch] parisc, iommu: add missing include for prefetchw()
In-Reply-To: <1318722499.7271.54.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.DEB.2.00.1110151739330.5728@chino.kir.corp.google.com>
References: <20111013233818.GB26654@one.firstfloor.org> <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com> <alpine.DEB.2.00.1110151536310.25063@chino.kir.corp.google.com> <1318722499.7271.54.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Oct 2011, James Bottomley wrote:

> This isn't physically possible on the parisc platform: prefetch.h is
> included by processor.h which, amongst other things, goes into
> spinlock.h which is above this file in sba_iommu.c
> 

asm/prefetch.h is included in processor.h, not linux/prefetch.h.  Thus, 
it's undefined for CONFIG_PA20=n.

> How did you try to compile this file?
> 

make allyesconfig
make drivers/parisc/sba_iommu.o
