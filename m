Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1EDAA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 20:00:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30044 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab1EDAA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 20:00:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=X8KZ5XYNExh1IFpKwFPxzFsrOv0zaZXzig6BHwoKjLFK1PPAKk58bqYgl9Ld+TxfLR
         7ClTnqQ8bLNzFixPV2eA==
Date: Tue, 3 May 2011 17:00:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v3] x86: allow ZONE_DMA to be configurable
In-Reply-To: <alpine.DEB.2.00.1104271637310.25369@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1105031700380.26030@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104141134260.386@chino.kir.corp.google.com> <4DA82F33.7080403@ladisch.de> <4DA8A5CE.2010004@zytor.com> <alpine.DEB.2.00.1104201929170.15661@chino.kir.corp.google.com> <4DAFAD9F.4020809@zytor.com>
 <alpine.DEB.2.00.1104271637310.25369@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011, David Rientjes wrote:

> ZONE_DMA is unnecessary for a large number of machines that do not
> require addressing in the lower 16MB of memory because they do not use
> devices with 16-bit address registers (plus one page byte register).
> 
> This patch allows users to disable ZONE_DMA for x86 if they know they
> will not be using such devices with their kernel.
> 
> This prevents the VM from unnecessarily reserving a ratio of memory
> (defaulting to 1/256th of system capacity) with lowmem_reserve_ratio
> for such allocations when it will never be used.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Peter, is this ready for merge?
