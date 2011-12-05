Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab1LEWab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:30:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:39859 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab1LEWaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:30:30 -0500
Message-ID: <1323124180.32012.45.camel@twins>
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86 (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov, will.deacon@arm.com, paulus@samba.org,
        benh@kernel.crashing.org, rth@twiddle.net, ralf@linux-mips.org,
        davem@davemloft.net, lethal@linux-sh.org
Date: Mon, 05 Dec 2011 23:29:40 +0100
In-Reply-To: <1318595833-29984-8-git-send-email-eranian@google.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	 <1318595833-29984-8-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 14:37 +0200, Stephane Eranian wrote:
> 
> This patch adds an internal sofware filter to complement
> the (optional) LBR hardware filter.
> 
> The software filter is necessary:
> - as a substitute when there is no HW LBR filter (e.g., Atom, Core)
> - to complement HW LBR filter in case of errata (e.g., Nehalem/Westmere)
> - to provide finer grain filtering (e.g., all processors)
> 
> Sometimes, the LBR HW filter cannot distinguish between two types
> of branches. For instance, to capture syscall as CALLS, it is necessary
> to enable the LBR_FAR filter which will also capture JMP instructions.
> Thus, a second pass is necessary to filter those out, this is what the
> SW filter can do.
> 
> The SW filter is built on top of the internal x86 disassembler. It
> is a best effort filter especially for user level code. It is subject
> to the availability of the text page of the program.
> 
> The SW filter is enabled on all Intel X86 processors. It is bypassed
> when the user is capturing all branches at all priv levels.

This patch is very seriously whitespace challenged. 
