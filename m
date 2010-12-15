Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab0LOJ1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 04:27:47 -0500
Received: from snowcat.de ([89.238.75.242]:47849 "EHLO snowcat.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0LOJ1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 04:27:45 -0500
Message-ID: <4D08899F.4050502@akana.de>
Date: Wed, 15 Dec 2010 10:25:51 +0100
From: Ingo Korb <ingo@akana.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-mm@kvack.org, akpm@linux-foundation.org, mel@csn.ul.ie,
        cl@linux-foundation.org, yinghai@kernel.org, andi.kleen@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: __offline_isolated_pages may offline too many pages
References: <4D0786D3.7070007@akana.de> <20101215092134.e2c8849f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101215092134.e2c8849f.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.12.2010 01:21, KAMEZAWA Hiroyuki wrote:

> It's designed for offline memory section>  MAX_ORDER. pageblock_nr_pages
> is tend to be smaller than that.
>
> Do you see the problem with _exsisting_ user interface of memory hotplug ?
> I think we have no control other than memory section.

The existing, exported interface (remove_memory() - the check itself is 
in offline_pages()) only checks if both start and end of the 
to-be-removed block are aligned to pageblock_nr_pages. As you noted the 
actual size and alignment requirements in __offline_isolated_pages can 
be larger that that, so I think the checks in offline_pages() should be 
changed (if 1<<MAX_ORDER is always >= pageblock_nr_pages) or extended 
(if there can be any relation between the two).

-ik
