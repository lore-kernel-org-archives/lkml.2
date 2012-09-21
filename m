Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab2IUNvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:51:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab2IUNvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:51:23 -0400
Message-ID: <505C70C8.5010406@redhat.com>
Date: Fri, 21 Sep 2012 09:51:04 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Avi Kivity <avi@redhat.com>, QEMU-devel <qemu-devel@nongnu.org>,
        KVM <kvm@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] Reduce compaction scanning and lock contention
References: <1348224383-1499-1-git-send-email-mgorman@suse.de>
In-Reply-To: <1348224383-1499-1-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 06:46 AM, Mel Gorman wrote:
> Hi Andrew,
>
> Richard Davies and Shaohua Li have both reported lock contention
> problems in compaction on the zone and LRU locks as well as
> significant amounts of time being spent in compaction. This series
> aims to reduce lock contention and scanning rates to reduce that CPU
> usage. Richard reported at https://lkml.org/lkml/2012/9/21/91 that
> this series made a big different to a problem he reported in August
> (http://marc.info/?l=kvm&m=134511507015614&w=2).

> One way or the other, this series has a large impact on the amount of
> scanning compaction does when there is a storm of THP allocations.

Andrew,

Mel and I have discussed the stuff in this series quite a bit,
and I am convinced this is the way forward with compaction.

-- 
All rights reversed
