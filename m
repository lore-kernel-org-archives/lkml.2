Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab0KLSrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:47:01 -0500
Received: from smtp-out.google.com ([74.125.121.35]:45243 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0KLSrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:47:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=iCnkmk/UNL6fcMMIsnaChbFJp4S3D4d/8h++PjPCo/KJILUvfrY9Dtxrlx89UhrfNH
         l2xRa1p8y+vcGA6VAbbw==
Date: Fri, 12 Nov 2010 10:46:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Richard Kennedy <richard@rsk.demon.co.uk>
cc: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH/RFC] MM slub: add a sysfs entry to show the calculated
 number of fallback slabs
In-Reply-To: <1289561309.1972.30.camel@castor.rsk>
Message-ID: <alpine.DEB.2.00.1011121043250.5830@chino.kir.corp.google.com>
References: <1289561309.1972.30.camel@castor.rsk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010, Richard Kennedy wrote:

> Add a slub sysfs entry to show the calculated number of fallback slabs.
> 
> Using the information already available it is straightforward to
> calculate the number of fallback & full size slabs. We can then track
> which slabs are particularly effected by memory fragmentation and how
> long they take to recover. 
> 
> There is no change to the mainline code, the calculation is only
> performed on request, and the value is available without having to
> enable CONFIG_SLUB_STATS.  
> 

I don't see why this information is generally useful unless debugging an 
issue where statistics are already needed such as ALLOC_SLOWPATH and 
ALLOC_SLAB, so it CONFIG_SLUB_STATS can be enabled to also track 
ORDER_FALLBACK.  All stats can be cleared by writing a '0' to its sysfs 
stats file so you can collect statistics for various workloads without 
rebooting (after doing a forced shrink, for example).
