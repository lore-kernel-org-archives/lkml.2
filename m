Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1AFUjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:39:32 -0500
Received: from smtp-out.google.com ([216.239.44.51]:6378 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1AFUjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:39:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=PYetSaeXtzSZdfZgD1IxQ5k8WYF0SVBqT9Y3gMqBKXgpLRcjTerVv/EoEOTffEmFqc
         5Z94JNV988JP10pvSMSg==
Date: Thu, 6 Jan 2011 12:39:27 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, numa: Fix CONFIG_DEBUG_PER_CPU_MAPS without NUMA
 emulation
In-Reply-To: <alpine.DEB.2.00.1012301053590.12995@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1101061238460.30820@chino.kir.corp.google.com>
References: <4D1BC856.4010202@kernel.org> <4D1BC94C.5040100@zytor.com> <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com> <alpine.DEB.2.00.1012291637270.6040@chino.kir.corp.google.com> <4D1BD928.50701@zytor.com> <alpine.DEB.2.00.1012291702180.7374@chino.kir.corp.google.com>
 <4D1BE615.4000700@zytor.com> <20101230090648.GB7306@elte.hu> <20101230102815.GA29822@elte.hu> <20101230103002.GA30020@elte.hu> <20101230120153.GA16476@elte.hu> <alpine.DEB.2.00.1012301052050.12995@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1012301053590.12995@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010, David Rientjes wrote:

> "x86, numa: Fake node-to-cpumask for NUMA emulation" broke the build when
> CONFIG_DEBUG_PER_CPU_MAPS is set and CONFIG_NUMA_EMU is not.  This is
> because it is possible to map a cpu to multiple nodes when NUMA emulation
> is used; the patch required a physical node address table to find those
> nodes that was only available when CONFIG_NUMA_EMU was enabled.
> 
> This extracts the common debug functionality to its own function for
> CONFIG_DEBUG_PER_CPU_MAPS and uses it regardless of whether
> CONFIG_NUMA_EMU is set or not.
> 
> NUMA emulation will now iterate over the set of possible nodes for each
> cpu and call the new debug function whereas only the cpu's node will be
> used without NUMA emulation enabled.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: David Rientjes <rientjes@google.com>

Ingo, do you know what the status of this fix is?  It's required for 
x86/numa to build and I'd hate to see all of this fixes miss .38 because 
of this failure.
