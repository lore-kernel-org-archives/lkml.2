Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab2AES2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:28:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46486 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab2AES2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:28:48 -0500
Date: Thu, 5 Jan 2012 19:28:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: x86-64: memset()/memcpy() not fully standards compliant
Message-ID: <20120105182846.GQ11715@one.firstfloor.org>
References: <4F05BBFE020000780006A983@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F05BBFE020000780006A983@nat28.tlf.novell.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 02:04:30PM +0000, Jan Beulich wrote:
> Forever these two functions have been limited to deal with at most 4G
> at a time. While I cannot point out an in-tree user that would require
> larger sizes, it is now the second time that within our Xen kernel we got
> bitten by that limitation. Would you nevertheless accept a patch to
> eliminate those shortcomings (iirc there may need to be workarounds
> for CPU bugs when it comes to using string instructions on such large
> blocks, albeit memmove() doesn't seem to care)?
> 
> Otherwise, is there any rationale for this sort of lurking bug?

Most (all?) of the CPUs I cared about when writing that code had 
bugs with string instructions and >4GB.

And I don't think anything in the kernel would ever process that big
areas in a single operation.

So it never seemed worth caring about.

You probably would need at least one more CMP & conditional jump
in the hot path, so everyone would pay for something that never happens.

-Andi
