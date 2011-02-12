Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab1BLR6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:58:52 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47428 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab1BLR6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:58:46 -0500
Message-ID: <4D56CA32.5060304@kernel.org>
Date: Sat, 12 Feb 2011 09:58:10 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 03/26] x86-64, NUMA: Drop @start/last_pfn from initmem_init()
References: <1297530663-26234-1-git-send-email-tj@kernel.org> <1297530663-26234-4-git-send-email-tj@kernel.org>
In-Reply-To: <1297530663-26234-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D56CA3A.00AC,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2011 09:10 AM, Tejun Heo wrote:
> initmem_init() extensively accesses and modifies global data
> structures and the parameters aren't even followed depending on which
> path is being used.  Drop @start/last_pfn and let it deal with
> @max_pfn directly.  This is in preparation for further NUMA init
> cleanups.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Brian Gerst <brgerst@gmail.com>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Shaohui Zheng <shaohui.zheng@intel.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/include/asm/page_types.h |    3 +--
>  arch/x86/kernel/setup.c           |    2 +-
>  arch/x86/mm/init_64.c             |    5 ++---
>  arch/x86/mm/numa_64.c             |   21 ++++++++-------------
>  4 files changed, 12 insertions(+), 19 deletions(-)

it will break 32bit.

Yinghai
