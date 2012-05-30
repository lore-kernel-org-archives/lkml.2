Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2E3PIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:08:37 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:36293 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab2E3PIf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Wed, 30 May 2012 11:08:35 -0400
Message-Id: <4FC6540E0200007800086EF7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 30 May 2012 16:08:30 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Andre Przywara" <andre.przywara@amd.com>, <mingo@elte.hu>,
        <jeremy@goop.org>, <tglx@linutronix.de>,
        <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org#3.4+>
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <20120530143937.GF3207@phenom.dumpdata.com> <4FC633A7.1050406@zytor.com>
In-Reply-To: <4FC633A7.1050406@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.05.12 at 16:50, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 05/30/2012 07:39 AM, Konrad Rzeszutek Wilk wrote:
>> On Wed, May 30, 2012 at 03:10:02PM +0200, Andre Przywara wrote:
>>> Because we are behind a family check before tweaking the topology
>>> bit, we can use the standard rd/wrmsr variants for the CPUID feature
>>> register.
>>> This fixes a crash when using the kernel as a Xen Dom0 on affected
>>> Trinity systems. The wrmsrl_amd_safe is not properly paravirtualized
>>> yet (this will be fixed in another patch).
>> 
>> So with a rdmsrl_amd_safe and wrmsrl_amd_safe being implemented in
>> the pv_cpu_ops - would this patch even be neccessary?
>> 
> 
> That is still bogus;  a better thing would be to implement the _regs
> interface.  Even better would be to trap and emulate rdmsr/wrmsr!

The crash is not on the wrmsr instruction, but on the paravirt
layer finding a NULL pointer in one of the methods. Xen does
trap and emulate (possibly just ignore) both instructions.

Jan

