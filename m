Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab0I0RjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:39:20 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4175 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759875Ab0I0RjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:39:19 -0400
Message-ID: <4CA0D6C2.7030901@caviumnetworks.com>
Date: Mon, 27 Sep 2010 10:39:14 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        konrad.wilk@oracle.com, mingo@elte.hu, andre.goddard@gmail.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH 7/9] swiotlb: Make bounce buffer bounds non-static.
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>	<1285282051-24907-2-git-send-email-ddaney@caviumnetworks.com> <20100927141616S.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100927141616S.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Sep 2010 17:39:18.0510 (UTC) FILETIME=[E95FB8E0:01CB5E6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2010 10:20 PM, FUJITA Tomonori wrote:
> On Thu, 23 Sep 2010 15:47:31 -0700
> David Daney<ddaney@caviumnetworks.com>  wrote:
>
>> Octeon PCI mapping has to be established to cover the bounce buffers,
>> so it has to have access to the bounds.
>
> Why can't you use swiotlb_init_with_tbl() instead?
>

Yes, as pointed out be several people, that would be better.

The swiotlb_init_with_tbl() didn't exist in earlier kernel versions and 
this simplification was missed when I forward ported the patch set.

By using this function, I think the entire patch set will be MIPS 
specific, making it unnecessary to touch the generic swiotlb code.

Thanks,
David Daney
