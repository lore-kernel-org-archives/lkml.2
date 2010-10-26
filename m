Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024Ab0JZQfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:35:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37492 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab0JZQfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:35:08 -0400
Message-ID: <4CC70333.80400@zytor.com>
Date: Tue, 26 Oct 2010 09:34:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kvm@vger.kernel.org, avi@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: fyi: gcc33-hammer crashes when compiling kvm emulate.c
References: <20101026123828.GA30434@basil.fritz.box>
In-Reply-To: <20101026123828.GA30434@basil.fritz.box>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2010 05:38 AM, Andi Kleen wrote:
> Hi,
> 
> While doing a test run with the minimum supported compiler
> I found:
> 
> An old gcc 3.3-hammer segfaults when compiling the current KVM
> emulate.c (or rather in x86_emulate_insns) on x86-64.
> 
> The compiler goes into an endless recursion in validate_rtx and then
> eventually overflows the stack and dies.
> 
> I minimized a test case, but didn't find a workaround
> (minimized test case http://halobates.de/emulate-min.i)
> 
> My guess it's related to some of the inline assembler uses.
> 
> This might be an excuse to bump the minimum compiler version again.
> 

We have said 3.4 minimum for x86 for a long time now, and have an RFC
out to bump to 4.1.  Unfortunately there isn't a good repo of
arch-specific version requirements in the kernel source code; in fact, I
just talked to Tony Luck yesterday about the need for that.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

