Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1GNBgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 21:36:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44222 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab1GNBgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 21:36:19 -0400
Message-ID: <4E1E47FE.7020400@zytor.com>
Date: Wed, 13 Jul 2011 18:35:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, tglx@linutronix.de, benh@kernel.crashing.org,
        yinghai@kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 04/13] x86: Use HAVE_MEMBLOCK_NODE_MAP
References: <1310462166-31469-1-git-send-email-tj@kernel.org> <1310462166-31469-5-git-send-email-tj@kernel.org>
In-Reply-To: <1310462166-31469-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 02:15 AM, Tejun Heo wrote:
> Convert x86 to HAVE_MEMBLOCK_NODE_MAP.  The only difference in memory
> handling is that allocations can't no longer cross node boundaries
> whether they're node affine or not, which shouldn't matter at all.
> 
> This conversion will enable further simplification of boot memory
> handling.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>

Hi Tejun,

This patch causes a build error on i386 allnoconfig:

/home/hpa/kernel/linux-2.6-tip.memblock/arch/x86/mm/init_32.c: In
function ‘initmem_init’:
/home/hpa/kernel/linux-2.6-tip.memblock/arch/x86/mm/init_32.c:653:2:
error: implicit declaration of function
‘memblock_x86_register_active_regions’
[-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

	-hpa
