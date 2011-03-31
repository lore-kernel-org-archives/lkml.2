Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1CaF1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 01:27:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60157 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab1CaF1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 01:27:44 -0400
Message-ID: <4D941084.5040700@kernel.org>
Date: Wed, 30 Mar 2011 22:26:28 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: stefano.stabellini@eu.citrix.com, ak@linux.intel.com, hpa@zytor.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: Re: [PATCH] [225/275] x86: Cleanup highmap after brk is concluded
References: <20110330203.501921634@firstfloor.org> <20110330210750.9B0D63E1A05@tassilo.jf.intel.com>
In-Reply-To: <20110330210750.9B0D63E1A05@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D941095.0073,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 02:07 PM, Andi Kleen wrote:
> 2.6.35-longterm review patch.  If anyone has any objections, please let me know.
>
> ------------------
> From: Yinghai Lu<yinghai@kernel.org>
>
> commit e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e upstream.
>
> Now cleanup_highmap actually is in two steps: one is early in head64.c
> and only clears above _end; a second one is in init_memory_mapping() and
> tries to clean from _brk_end to _end.
> It should check if those boundaries are PMD_SIZE aligned but currently
> does not.
> Also init_memory_mapping() is called several times for numa or memory
> hotplug, so we really should not handle initial kernel mappings there.
>
> This patch moves cleanup_highmap() down after _brk_end is settled so
> we can do everything in one step.
> Also we honor max_pfn_mapped in the implementation of cleanup_highmap.
>

gentoo guys reported this one cause resume freeze.

https://bugs.gentoo.org/show_bug.cgi?id=361159

