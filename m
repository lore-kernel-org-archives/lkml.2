Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977Ab2JaWpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:45:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43807 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760923Ab2JaWp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:45:29 -0400
Date: Wed, 31 Oct 2012 23:45:23 +0100
From: Robert Richter <rric@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Zhang, Jun" <jun.zhang@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Sometimes, there is OOPS happened when we use oprofile.
Message-ID: <20121031224523.GF4386@ivy.homofaber>
References: <88DC34334CA3444C85D647DBFA962C270FD7E416@SHSMSX102.ccr.corp.intel.com>
 <20121031210522.GB4386@ivy.homofaber>
 <5091991D.4020202@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5091991D.4020202@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.10.12 14:33:17, H. Peter Anvin wrote:
> I'm vaguely concerned about the following:
> 
> + * To always return a non-null
> + * stack pointer we fall back to regs as stack if no previous stack
> + * exists.
> 
> The logic being that if there is no stack pointer and the stack is
> too empty, to simply assume regs point to the top of the stack?  Is
> this possible to ever be actually seen?

I discussed this with Steven too (https://lkml.org/lkml/2012/9/6/322)
and we both had a bad feeling with returning a null pointer by
kernel_stack_pointer() (implemented in version 1 of this patch). It
could be null if tinfo->previous_esp is null (last stack). Not sure
when this may happen.

So using regs as fallback seemed to be ok as this was in for years:

 7b6c6c7 x86, 32-bit: fix kernel_trap_sp()

-Robert
