Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab0JMUxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 16:53:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36996 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab0JMUxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:53:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kgA55o/7T+3ErQRrUvbA249LILlq4zib4VOq/aD7oyvv+Aovw+1uaBp9YBO4FrCqSu
         DmY2FvE7uPx+XzeQwLXA==
Date: Wed, 13 Oct 2010 13:53:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Casey Dahlin <cdahlin@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: A question about ZONE_DMA
In-Reply-To: <20101013145240.GE12467@foucault.redhat.com>
Message-ID: <alpine.DEB.2.00.1010131351520.15185@chino.kir.corp.google.com>
References: <20101013145240.GE12467@foucault.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010, Casey Dahlin wrote:

> Hi all,
> 
> So if I understand correctly, ZONE_DMA exists to separate and preserve the
> chunk of memory to which older ISA cards are capable of doing DMA. The question
> that arises for me is:
> 
> 1) Why do /all/ 32-bit boxes have a ZONE_DMA when surely only a tiny and
> shrinking number of them have a need for it?
> 

If you don't need it, disable CONFIG_ZONE_DMA, which is useful to prevent 
oom conditions when lowmem_reserve_ratio reserves memory in that zone that 
you'll never need to save.

If you do disable that option, you may also want to look at disabling 
CONFIG_GENERIC_ISA_DMA and CONFIG_ISA_DMA_API which you need to hack a 
little to get to compile.  I'll send a patch to fix that.
