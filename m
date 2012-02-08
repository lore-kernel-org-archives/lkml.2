Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab2BHMvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 07:51:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41697 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2BHMvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 07:51:13 -0500
MIME-Version: 1.0
In-Reply-To: <20120207132745.GH5938@suse.de>
References: <1328568978-17553-1-git-send-email-mgorman@suse.de>
	<CAJd=RBAvvzK=TXwDaEjq2t+uEuP2PSi6zaUj7EW4UbL_AUsJAg@mail.gmail.com>
	<20120207132745.GH5938@suse.de>
Date: Wed, 8 Feb 2012 20:51:11 +0800
Message-ID: <CAJd=RBDYMKRVSKVp3dAhTCtu_wNDyayCObVA7q6G=fbkKpmZUw@mail.gmail.com>
Subject: Re: [PATCH 00/15] Swap-over-NBD without deadlocking V8
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 9:27 PM, Mel Gorman <mgorman@suse.de> wrote:
> On Tue, Feb 07, 2012 at 08:45:18PM +0800, Hillf Danton wrote:
>> If it is feasible to bypass hang by tuning min_mem_kbytes,
>
> No. Increasing or descreasing min_free_kbytes changes the timing but it
> will still hang.
>
>> things may
>> become simpler if NICs are also tagged.
>
> That would mean making changes to every driver and they do not necessarily
> know what higher level protocol like TCP they are transmitting. How is
> that simpler? What is the benefit?
>
The benefit is to avoid allocating sock buffer in softirq by recycling,
then the changes in VM core maybe less.

Thanks
Hillf
