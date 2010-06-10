Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab0FJJnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 05:43:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab0FJJnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 05:43:16 -0400
Message-ID: <4C10B3AF.7020908@redhat.com>
Date: Thu, 10 Jun 2010 12:43:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page cache
 control
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com> <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>
In-Reply-To: <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 06:51 PM, Balbir Singh wrote:
> Balloon unmapped page cache pages first
>
> From: Balbir Singh<balbir@linux.vnet.ibm.com>
>
> This patch builds on the ballooning infrastructure by ballooning unmapped
> page cache pages first. It looks for low hanging fruit first and tries
> to reclaim clean unmapped pages first.
>    

I'm not sure victimizing unmapped cache pages is a good idea.  Shouldn't 
page selection use the LRU for recency information instead of the cost 
of guest reclaim?  Dropping a frequently used unmapped cache page can be 
more expensive than dropping an unused text page that was loaded as part 
of some executable's initialization and forgotten.

Many workloads have many unmapped cache pages, for example static web 
serving and the all-important kernel build.

> The key advantage was that it resulted in lesser RSS usage in the host and
> more cached usage, indicating that the caching had been pushed towards
> the host. The guest cached memory usage was lower and free memory in
> the guest was also higher.
>    

Caching in the host is only helpful if the cache can be shared, 
otherwise it's better to cache in the guest.

-- 
error compiling committee.c: too many arguments to function

