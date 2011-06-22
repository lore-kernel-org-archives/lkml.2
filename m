Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab1FVPTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:19:40 -0400
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:44289 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932256Ab1FVPTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:19:38 -0400
Message-ID: <4E0207FE.9080002@ravellosystems.com>
Date: Wed, 22 Jun 2011 18:19:26 +0300
From: Izik Eidus <izik.eidus@ravellosystems.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Nai Xia <nai.xia@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte
 and mmu notifier to help KSM dirty bit tracking
References: <201106212055.25400.nai.xia@gmail.com> <201106212132.39311.nai.xia@gmail.com> <20110622150350.GX20843@redhat.com>
In-Reply-To: <20110622150350.GX20843@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If we don't flush the smp tlb don't we risk that we'll insert pages in
> the unstable tree that are volatile just because the dirty bit didn't
> get set again on the spte?

Yes, this is the trade off we take, the unstable tree will be flushed 
anyway -
so this is nothing that won`t be recovered very soon after it happen...

and most of the chances the tlb will be flushed before ksm get there anyway
(specially for heavily modified page, that we don`t want in the unstable 
tree)
