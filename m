Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab1FVDNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 23:13:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757504Ab1FVDNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 23:13:48 -0400
Message-ID: <4E015DCA.8040204@redhat.com>
Date: Wed, 22 Jun 2011 11:13:14 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] mm: introduce no_ksm to disable totally KSM
References: <1308643849-3325-1-git-send-email-amwang@redhat.com> <1308643849-3325-4-git-send-email-amwang@redhat.com> <20110621133236.GP20843@redhat.com>
In-Reply-To: <20110621133236.GP20843@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月21日 21:32, Andrea Arcangeli 写道:
> On Tue, Jun 21, 2011 at 04:10:45PM +0800, Amerigo Wang wrote:
>> Introduce a new kernel parameter "no_ksm" to totally disable KSM.
>
> Here as well this is the wrong approach. If you want to save memory,
> you should make ksmd quit when run=0 and start only when setting
> ksm/run=1. And move the daemon hashes and slabs initializations to the
> ksmd daemon start. Not registering in sysfs and crippling down the
> feature despite you loaded the proper .text into memory isn't good.

1. Not only about saving memory, as I explained in other thread.

2. Recompiling kernel is not always acceptable, as I replied in other thread.
