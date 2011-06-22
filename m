Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab1FVPj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:39:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246Ab1FVPjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:39:55 -0400
Message-ID: <4E020CBC.7070604@redhat.com>
Date: Wed, 22 Jun 2011 11:39:40 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Izik Eidus <izik.eidus@ravellosystems.com>
CC: Avi Kivity <avi@redhat.com>, nai.xia@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte
 and mmu notifier to help KSM dirty bit tracking
References: <201106212055.25400.nai.xia@gmail.com> <201106212132.39311.nai.xia@gmail.com> <4E01C752.10405@redhat.com> <4E01CC77.10607@ravellosystems.com> <4E01CDAD.3070202@redhat.com> <4E01CFD2.6000404@ravellosystems.com>
In-Reply-To: <4E01CFD2.6000404@ravellosystems.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 07:19 AM, Izik Eidus wrote:

> So what we say here is: it is better to have little junk in the unstable
> tree that get flushed eventualy anyway, instead of make the guest
> slower....
> this race is something that does not reflect accurate of ksm anyway due
> to the full memcmp that we will eventualy perform...

With 2MB pages, I am not convinced they will get "flushed eventually",
because there is a good chance at least one of the 4kB pages inside
a 2MB page is in active use at all times.

I worry that the proposed changes may end up effectively preventing
KSM from scanning inside 2MB pages, when even one 4kB page inside
is in active use.  This could mean increased swapping on systems
that run low on memory, which can be a much larger performance penalty
than ksmd CPU use.

We need to scan inside 2MB pages when memory runs low, regardless
of the accessed or dirty bits.

-- 
All rights reversed
