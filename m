Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1GADmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 23:42:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771Ab1GADms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 23:42:48 -0400
MIME-Version: 1.0
In-Reply-To: <1309479572.2665.1372.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1309479572.2665.1372.camel@sbsiddha-MOBL3.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 30 Jun 2011 20:42:09 -0700
Message-ID: <BANLkTikekBSzT-fQGJEk-U5JEuTsGQsBvQ@mail.gmail.com>
Subject: Re: [patch] x32, fpu: fix DNA exception during check_fpu()
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 5:19 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
>
> Before check_fpu() is called, we have cr0.TS bit set and hence the floating
> point code to check the FDIV bug was generating a DNA exception.
>
> Use kernel_fpu_begin()/kernel_fpu_end() around the floating point
> code to avoid this unnecessary device not available exception during
> boot.

Looks sane to me. I didn't think we were supposed to set the TS bit
this early, but if we do, Ack.

                 Linus
