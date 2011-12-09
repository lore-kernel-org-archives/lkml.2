Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab1LIKoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 05:44:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56982 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab1LIKoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 05:44:21 -0500
Date: Fri, 9 Dec 2011 02:44:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Petr Holasek <pholasek@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH v3] NUMA x86: add constraints check for nid parameters
In-Reply-To: <20111209071001.GD24537@elte.hu>
Message-ID: <alpine.DEB.2.00.1112090219500.15325@chino.kir.corp.google.com>
References: <1322739907-4695-1-git-send-email-pholasek@redhat.com> <20111201133451.5fc1ee7b.akpm@linux-foundation.org> <20111201231441.GA3293@stainedmachine.redhat.com> <20111201152851.7e39f034.akpm@linux-foundation.org> <20111202105538.GB2188@dhcp-27-244.brq.redhat.com>
 <alpine.DEB.2.00.1112061233330.28251@chino.kir.corp.google.com> <20111207194311.GB26060@dhcp-27-244.brq.redhat.com> <alpine.DEB.2.00.1112071342450.27360@chino.kir.corp.google.com> <20111208121640.GA2229@dhcp-27-244.brq.redhat.com>
 <alpine.DEB.2.00.1112081308430.8127@chino.kir.corp.google.com> <20111209071001.GD24537@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Dec 2011, Ingo Molnar wrote:

> Thanks guys.
> 
> Just to double check: there's no known instance of such a bad 
> SRAT in existence, so this commit can wait until v3.3 and does 
> hot have to go into v3.2, right?
> 

Andi mentioned buggy SRATs, but it's outside the scope of this patch; this 
has nothing to do with buggy SRATs.

Ignoring NUMA emulation which plays with these when you boot with 
numa=fake, this patch is catching any instance where pxm_to_node(x) 
returns NUMA_NO_NODE, meaning x is not an initialized pxm.  For x86, we 
initialize pxms by grabbing them from the SRAT, picking the first unused 
node id, and mapping them.  The SRAT has nothing to do with this, the ACPI 
spec has no notion of what we've defined a node to be.  So Petr's patch 
will simply catch any instance of pxm_to_node(x) where x was not 
initialized and incorrectly referencing 
