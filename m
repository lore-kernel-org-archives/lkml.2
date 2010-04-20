Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab0DTCji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 22:39:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42298 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab0DTCjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 22:39:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 20 Apr 2010 11:35:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: error at compaction  (Re: mmotm 2010-04-15-14-42 uploaded
Message-Id: <20100420113544.b06be095.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100419181442.GA19264@csn.ul.ie>
References: <201004152210.o3FMA7KV001909@imap1.linux-foundation.org>
	<20100419190133.50a13021.kamezawa.hiroyu@jp.fujitsu.com>
	<20100419181442.GA19264@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010 19:14:42 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> On Mon, Apr 19, 2010 at 07:01:33PM +0900, KAMEZAWA Hiroyuki wrote:

> I'll verify the theory tomorrow but it's a plausible explanation. On a
> different note, where did config options like the following come out of?
> 
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" 
> 
> I don't think they are a factor but I'm curious.
> 

Hmm ? arch/x86/Kconfig.

config ARCH_HWEIGHT_CFLAGS
        string
        default "-fcall-saved-ecx -fcall-saved-edx" if X86_32
        default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64


Seems to be from
patches/x86-add-optimized-popcnt-variants.patch

Thanks,
-Kame

