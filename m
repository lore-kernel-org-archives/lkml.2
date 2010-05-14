Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab0ENC26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:28:58 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:47674 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab0ENC25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:28:57 -0400
Message-ID: <4BECB562.2080200@cesarb.net>
Date: Thu, 13 May 2010 23:28:50 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] radix-tree: fix radix_tree_prev_hole underflow case
References: <1273802724-3414-1-git-send-email-cesarb@cesarb.net> <20100514021508.GA7810@localhost>
In-Reply-To: <20100514021508.GA7810@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 13-05-2010 23:15, Wu Fengguang escreveu:
> On Fri, May 14, 2010 at 10:05:24AM +0800, Cesar Eduardo Barros wrote:
>> radix_tree_prev_hole() used LONG_MAX to detect underflow; however,
>> ULONG_MAX is clearly what was intended, both here and by its only user
>> (count_history_pages at mm/readahead.c).
>
> Good catch, thanks! I actually have a more smart
> radix_tree_prev_hole() that uses ULONG_MAX.

I saw it already ([PATCH 14/16] radixtree: speed up the search for 
hole), but it misses the LONG_MAX in the documentation comment.

> Andrew, fortunately this bug has little impact on readahead.

I agree, if I read it correctly it should only have any impact either 
when very near LONG_MAX or in the unlikely case that there is no hole at 
ULONG_MAX. And even then, the impact should be limited.

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
