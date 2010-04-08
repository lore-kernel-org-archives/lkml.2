Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab0DHXaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 19:30:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:51752 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757559Ab0DHXaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 19:30:15 -0400
Message-ID: <4BBE67B9.9050700@kernel.org>
Date: Fri, 09 Apr 2010 08:33:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sonic Zhang <sonic.adi@gmail.com>
CC: graff yang <graff.yang@gmail.com>, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] mm/nommu.c:Dynamic alloc/free percpu area for nommu
References: <1268989324-7575-1-git-send-email-graff.yang@gmail.com>	 <4BA449E2.3080707@kernel.org>	 <7d86d44a1003211933h6628ae04vc9d1c393e1733ce5@mail.gmail.com>	 <4BB47367.8030305@kernel.org>	 <y2l4e5ebad51004060228t814129beqd0d90059e247e48d@mail.gmail.com>	 <4BBD42BE.20307@kernel.org> <x2p4e5ebad51004080240nc3f5846am27fa259debf04302@mail.gmail.com>
In-Reply-To: <x2p4e5ebad51004080240nc3f5846am27fa259debf04302@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Apr 2010 23:29:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/08/2010 06:40 PM, Sonic Zhang wrote:
> There is memory leak with you patch. Free memory continuously
> decreases when running test_pcpu. After about 30 minutes, kernel hangs
> in out_of_memory().
> 
> root/> while [ 1 ]; do modprobe test_pcpu; rmmod test_pcpu; cat
> proc/meminfo; done

Yeap, chunk->map wasn't freed in the original version.  In the updated
split version I posted yesterday, it's fixed.  Can you please test
that code?

Thanks.

-- 
tejun
