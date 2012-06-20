Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab2FTCwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 22:52:22 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:51447 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab2FTCwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 22:52:21 -0400
Message-ID: <4FE13ACA.7090301@linux.vnet.ibm.com>
Date: Wed, 20 Jun 2012 10:51:54 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 01/10] zcache: fix preemptable memory allocation in atomic
 context
References: <4FE0392E.3090300@linux.vnet.ibm.com> <4FE08C1A.2020308@linux.vnet.ibm.com>
In-Reply-To: <4FE08C1A.2020308@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062002-3864-0000-0000-000003683834
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 10:26 PM, Seth Jennings wrote:


> Did you get a might_sleep warning on this?  I haven't seen this being an
> issue.
> 


No, i did not, i get it just from code review.

> GFP_ATOMIC only modifies the existing mask to allow allocation use the
> emergency pool.  It is __GFP_WAIT not being set that prevents sleep.  We
> don't want to use the emergency pool since we make large, long lived
> allocations with this mask.
> 


Ah, yes, i thought only GFP_ATOMIC can prevent sleep, thank you very much
for pointing it out.

