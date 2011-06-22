Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab1FVLb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:31:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582Ab1FVLb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:31:27 -0400
Message-ID: <4E01D27F.8080304@redhat.com>
Date: Wed, 22 Jun 2011 14:31:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Izik Eidus <izik.eidus@ravellosystems.com>
CC: nai.xia@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte
 and mmu notifier to help KSM dirty bit tracking
References: <201106212055.25400.nai.xia@gmail.com> <201106212132.39311.nai.xia@gmail.com> <4E01C752.10405@redhat.com> <4E01CC77.10607@ravellosystems.com> <4E01CDAD.3070202@redhat.com> <4E01CFD2.6000404@ravellosystems.com> <4E01D0E3.9080508@redhat.com> <4E01D1C8.2050707@redhat.com>
In-Reply-To: <4E01D1C8.2050707@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 02:28 PM, Avi Kivity wrote:
>
> Actually, this is dangerous.  If we use the dirty bit for other 
> things, we will get data corruption.
>
> For example we might want to map clean host pages as writeable-clean 
> in the spte on a read fault so that we don't get a page fault when 
> they get eventually written.
>

Another example - we can use the dirty bit for dirty page loggging.

So I think we can get away with a conditional tlb flush - only flush if 
the page was dirty.  That should be rare after the first pass, at least 
with small pages.

-- 
error compiling committee.c: too many arguments to function

