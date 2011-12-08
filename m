Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1LHVMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 16:12:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53858 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1LHVMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 16:12:51 -0500
Date: Thu, 8 Dec 2011 13:12:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Petr Holasek <pholasek@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH v2] NUMA x86: add constraints check for nid parameters
In-Reply-To: <m2mxb2nb58.fsf@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1112081309290.8127@chino.kir.corp.google.com>
References: <1322739907-4695-1-git-send-email-pholasek@redhat.com> <20111201133451.5fc1ee7b.akpm@linux-foundation.org> <20111201231441.GA3293@stainedmachine.redhat.com> <20111201152851.7e39f034.akpm@linux-foundation.org> <20111202105538.GB2188@dhcp-27-244.brq.redhat.com>
 <alpine.DEB.2.00.1112061233330.28251@chino.kir.corp.google.com> <20111207194311.GB26060@dhcp-27-244.brq.redhat.com> <m2mxb2nb58.fsf@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011, Andi Kleen wrote:

> > This patch adds constraints checks for numa_set_distance()
> > function. It emits warning when pxms are used uninitialized
> > when parsing the SRAT.
> 
> Can you expand on the motivation for this please?

It's adding a debugging check if something erroneously passes a negative 
node id when setting a distance, perhaps because of buggy code that failed 
to initialize the pxm-to-node mapping correctly which would result in 
storing to a negative index of the numa_distance array as indicated in the 
changelog.  It's for robustness and to warn explicitly rather than 
silently rejecting it unless you're monitoring debug output.
