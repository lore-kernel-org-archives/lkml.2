Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0IJQED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:04:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53642 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab0IJQEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:04:01 -0400
Date: Fri, 10 Sep 2010 18:03:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/6] x86, NMI, Rewrite NMI handler
Message-ID: <20100910180356.44ac7097@basil.nowhere.org>
In-Reply-To: <20100910155605.GG4879@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	<1284087065-32722-4-git-send-email-ying.huang@intel.com>
	<20100910155605.GG4879@redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 11:56:05 -0400
Don Zickus <dzickus@redhat.com> wrote:

> On Fri, Sep 10, 2010 at 10:51:03AM +0800, Huang Ying wrote:
> > The original NMI handler is quite outdated in many aspects. This
> > patch try to fix it.
> > 
> > In original code, NMI reason io port (0x61) is only processed on
> > BSP. This makes it impossible to hot-remove BSP. To solve the issue,
> > a raw spinlock is used to make the port can be processed on any CPU.
> 
> Do we really want to use a spinlock inside the nmi handler?

As long as it's only between CPUs
(that is only ever used between different NMI handlers) 
that's fine.  It's certainly safer than having races between CPUs.

> I thought the NMIs sent to the io port are only routed to one cpu as
> determined by the io-apic?  Is it spread out to other cpus now?

There can be cases where it can happen I believe.

-Andi
 
-- 
ak@linux.intel.com -- Speaking for myself only.
