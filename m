Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab2DSBll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 21:41:41 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:39867 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab2DSBlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 21:41:40 -0400
Message-ID: <1334799635.10478.9.camel@ThinkPad-T420>
Subject: Re: [PATCH mm] limit the mm->map_count not greater than
 sysctl_max_map_count
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Date: Wed, 18 Apr 2012 21:40:35 -0400
In-Reply-To: <4F8EC161.5050307@gmail.com>
References: <1334741239.30072.7.camel@ThinkPad-T420>
	 <4F8EC161.5050307@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12041901-4790-0000-0000-0000023E9798
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 21:28 +0800, Cong Wang wrote:
> On 04/18/2012 05:27 PM, Li Zhong wrote:
> > When reading the mmap codes, I found the checking of mm->map_count
> > against sysctl_max_map_count is not consistent. At some places, ">" is
> > used; at some other places, ">=" is used.
> >
> > This patch changes ">" to">=", so they are consistent, and makes sure
> > the value is not greater (one more) than sysctl_max_map_count.
> >
> 
> Well, according to Documentation/sysctl/vm.txt,
> 
> max_map_count:
> 
> This file contains the maximum number of memory map areas a process
> may have. [...]
> 
> I think ->map_count == sysctl_max_map_count should be allowed, so using 
> '>' is correct.
> 
Yes, I agree that ->map_count == sysctl_max_map_count should be allowed.
However, with '>' used. The ->map_count could be sysctl_max_map_count+1.
It could be seen with a simple program doing continuously mmaping of a
file. 

( Still it is possible, as stated in the comments of do_munmap code, if
the VMA is going to be divided into two, the map_count could temporarily
be sysctl_max_map_count+1, after the original vma split into two, and
before one of the two vmas removed. ) 


