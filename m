Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455Ab1FWAAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 20:00:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758245Ab1FWAAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 20:00:35 -0400
Message-ID: <4E028215.90107@redhat.com>
Date: Wed, 22 Jun 2011 20:00:21 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Nai Xia <nai.xia@gmail.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte
 and mmu notifier to help KSM dirty bit tracking
References: <201106212055.25400.nai.xia@gmail.com>	<201106212132.39311.nai.xia@gmail.com>	<4E01C752.10405@redhat.com>	<4E01CC77.10607@ravellosystems.com>	<4E01CDAD.3070202@redhat.com>	<4E01CFD2.6000404@ravellosystems.com>	<4E020CBC.7070604@redhat.com>	<20110622165529.GY20843@redhat.com> <BANLkTinRYr9Vg==C-qyCaRmO7C_aQqBPzw@mail.gmail.com>
In-Reply-To: <BANLkTinRYr9Vg==C-qyCaRmO7C_aQqBPzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 07:37 PM, Nai Xia wrote:

> On 2MB pages, I'd like to remind you and Rik that ksmd currently splits
> huge pages before their sub pages gets really merged to stable tree.

Your proposal appears to add a condition that causes ksmd to skip
doing that, which can cause the system to start using swap instead
of sharing memory.

> So when there are many 2MB pages each having a 4kB subpage
> changed for all time, this is already a concern for ksmd to judge
> if it's worthwhile to split 2MB page and get its sub-pages merged.
> I think the policy for ksmd in a system should be "If you cannot do sth good,
> at least do nothing evil". So I really don't think we can satisfy _all_ people.
> Get a general method and give users one or two knobs to tune it when they
> are the corner cases. How do  you think of my proposal ?

I think your proposal makes sense for 4kB pages, but the ksmd
policy for 2MB pages probably needs to be much more aggressive.

-- 
All rights reversed
