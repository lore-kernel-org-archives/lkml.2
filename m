Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab1JOXsY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 19:48:24 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45979 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126Ab1JOXsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 19:48:23 -0400
Subject: Re: [patch] parisc, iommu: add missing include for prefetchw()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1110151536310.25063@chino.kir.corp.google.com>
References: <20111013233818.GB26654@one.firstfloor.org>
	 <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com>
	 <alpine.DEB.2.00.1110151536310.25063@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Oct 2011 18:48:19 -0500
Message-ID: <1318722499.7271.54.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-15 at 15:38 -0700, David Rientjes wrote:
> prefetchw() requires it to be defined by linux/prefetch.h, or it results
> in a compile error:
> 
> In file included from drivers/parisc/sba_iommu.c:916:0:
> drivers/parisc/iommu-helpers.h: In function 'iommu_fill_pdir':
> drivers/parisc/iommu-helpers.h:62:4: error: implicit declaration of function 'prefetchw'
> 
> Include linux/prefetch.h.

This isn't physically possible on the parisc platform: prefetch.h is
included by processor.h which, amongst other things, goes into
spinlock.h which is above this file in sba_iommu.c

How did you try to compile this file?

James


