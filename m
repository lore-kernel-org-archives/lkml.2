Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab0IJP42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:56:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279Ab0IJP40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:56:26 -0400
Date: Fri, 10 Sep 2010 11:56:05 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 4/6] x86, NMI, Rewrite NMI handler
Message-ID: <20100910155605.GG4879@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284087065-32722-4-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284087065-32722-4-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 10:51:03AM +0800, Huang Ying wrote:
> The original NMI handler is quite outdated in many aspects. This patch
> try to fix it.
> 
> In original code, NMI reason io port (0x61) is only processed on
> BSP. This makes it impossible to hot-remove BSP. To solve the issue,
> a raw spinlock is used to make the port can be processed on any CPU.

Do we really want to use a spinlock inside the nmi handler?

I thought the NMIs sent to the io port are only routed to one cpu as
determined by the io-apic?  Is it spread out to other cpus now?

Cheers,
Don
