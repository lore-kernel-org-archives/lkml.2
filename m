Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0INULQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:11:16 -0400
Received: from freeflow.nu ([178.79.134.28]:35919 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab0INULP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:11:15 -0400
Message-ID: <4C8FD6E1.3040507@kernel.org>
Date: Tue, 14 Sep 2010 23:11:13 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
References: <1284490101-2362-1-git-send-email-penberg@kernel.org> <1284490101-2362-2-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141243290.1470@chino.kir.corp.google.com> <AANLkTinj2P_QbdgdLS3BweSMDzhQH5g4p2B3SqS=CNYc@mail.gmail.com>
In-Reply-To: <AANLkTinj2P_QbdgdLS3BweSMDzhQH5g4p2B3SqS=CNYc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 14.9.2010 23.05, Linus Torvalds wrote:
> On Tue, Sep 14, 2010 at 1:00 PM, David Rientjes<rientjes@google.com>  wrote:
>> I can understand how it's confusing that only the first slab cache name is
>> being emitted, and I think that can be changed, but this shows way too
>> much information that is already available when CONFIG_SLUB_DEBUG is used
>> via the sysfs interface.
> Umm. Not in any readable form, it isn't.
>
> The cause for this is that I made a bug-report about the wrong slab
> info, with me claiming 400+ thousand entries (taking up 10M of memory)
> for a slub cache that turned out to be entirely innocent.
>
> That's what /proc/slabinfo said, and quite frankly, /proc/slabinfo was
> simply _lying_. It gave very misleading output.
>
> In my not-so-humble opinion, either the merging needs to go away
> entirely, or the misleading output needs to be fixed. The whole (and
> _only_) reason for /proc/slabinfo is to show where memory is being
> used, so if that file is misleading, then it's worse than useless.
> Pointing to some other /sys file as having more information doesn't
> change that in the least.
Are you happy with the patch? The output is indeed tad bit unreadable. 
Maybe we should just limit the number of printed out names to two or three?

             Pekka
