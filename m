Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab1CIOi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:38:59 -0500
Received: from smtp.nokia.com ([147.243.1.48]:48157 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932613Ab1CIOi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:38:56 -0500
Date: Wed, 9 Mar 2011 16:36:35 +0200 (EET)
From: Aaro Koskinen <aaro.koskinen@nokia.com>
X-X-Sender: aakoskin@esdhcp041196.research.nokia.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Aaro Koskinen <aaro.koskinen@nokia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
        stable@kernel.org
Subject: Re: [PATCHv2] procfs: fix /proc/<pid>/maps heap check
In-Reply-To: <20110307150756.d50635f1.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.1103091631280.23039@esdhcp041196.research.nokia.com>
References: <1299244994-5284-1-git-send-email-aaro.koskinen@nokia.com> <20110307150756.d50635f1.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 7 Mar 2011, Andrew Morton wrote:
> On Fri,  4 Mar 2011 15:23:14 +0200
> Aaro Koskinen <aaro.koskinen@nokia.com> wrote:
>
>> The current code fails to print the "[heap]" marking if the heap is
>> splitted into multiple mappings.
>>
>> Fix the check so that the marking is displayed in all possible cases:
>> 	1. vma matches exactly the heap
>> 	2. the heap vma is merged e.g. with bss
>> 	3. the heap vma is splitted e.g. due to locked pages
>>
>> Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
>> Cc: stable@kernel.org
>
> Why do you believe this problem is serious enough to justify
> backporting the fix into -stable?

My bad analysis. It looks like the bug has been there forever, and
since it only results in some information missing from a procfile,
it does not fulfil the stable "critical issue" criteria.

A.
