Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082Ab0HLNLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 09:11:54 -0400
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:29789 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760068Ab0HLNLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 09:11:53 -0400
Message-ID: <4C63F368.9050806@ixiacom.com>
Date: Thu, 12 Aug 2010 16:13:12 +0300
From: Alex Badea <abadea@ixiacom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.24) Gecko/20100228 Thunderbird/2.0.0.24 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [xfrm_user] BUG: sleeping function called from invalid context
References: <20100812125027.GA12982@nb-core2.darkstar.lan>
In-Reply-To: <20100812125027.GA12982@nb-core2.darkstar.lan>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Aug 2010 13:11:51.0634 (UTC) FILETIME=[EDB04320:01CB3A1F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/12/2010 03:50 PM, Luca Tettamanti wrote:
>  [<ffffffff8124d175>] udp_setsockopt+0x24/0x26
>  [<ffffffff811fd5c5>] sock_common_setsockopt+0xf/0x11
>  [<ffffffff811fb0a8>] sys_setsockopt+0x81/0xa2
>  [<ffffffff8100296b>] system_call_fastpath+0x16/0x1b
> 
> 
> xfrm_user_policy takes read_lock(&xfrm_km_lock) before calling
> xfrm_compile_policy (via km->compile_policy), which in turn calls
> xfrm_policy_alloc with GFP_KERNEL.

Since it's a setsockopt(), I suspect it was setting up per-socket bypass
policies.

Regards,
Alex
