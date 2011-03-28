Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab1C1PXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:23:37 -0400
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:34258 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754535Ab1C1PXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:23:34 -0400
X-Greylist: delayed 1350 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Mar 2011 11:23:34 EDT
Message-ID: <4D90A236.9030200@ravellosystems.com>
Date: Mon, 28 Mar 2011 16:59:02 +0200
From: Izik Eidus <izik.eidus@ravellosystems.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: nai.xia@gmail.com
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Chris Wright <chrisw@sous-sol.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 0/2] ksm: take dirty bit as reference to avoid volatile
 pages
References: <201103282214.19345.nai.xia@gmail.com>
In-Reply-To: <201103282214.19345.nai.xia@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2011 04:14 PM, Nai Xia wrote:
> Currently, ksm uses page checksum to detect volatile pages. Izik Eidus
> suggested that we could use pte dirty bit to optimize. This patch series
> adds this new logic.
>

Hi,

One small note:
When kvm will use ksm on intel cpu with extended page tables support, 
the cpu won`t track
dirty bit, therefore the calc_hash() logic should be used in such cases
(untill intel will fadd this support in their cpus)...

Moreover I think that even though that AMD nested page tables does 
update dirty bit, you still need
to sync it with the host page table using mmu notifiers ?

(Not that on regular application use case of ksm any of this should be 
an issue)

