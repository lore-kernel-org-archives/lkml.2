Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab2GKTSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:18:07 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45487 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab2GKTSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:18:05 -0400
Message-ID: <4FFDD12B.1050909@linux.vnet.ibm.com>
Date: Wed, 11 Jul 2012 14:16:59 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] zsmalloc improvements
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com> <4FFD2524.2050300@kernel.org>
In-Reply-To: <4FFD2524.2050300@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071119-7606-0000-0000-000001ECDCEE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 02:03 AM, Minchan Kim wrote:
> Today, I tested zsmapbench in my embedded board(ARM).
> tlb-flush is 30% faster than copy-based so it's always not win.
> I think it depends on CPU speed/cache size.

After you pointed this out, I decided to test this on my
Raspberry Pi, the only ARM system I have that is open enough
for me to work with.

I pulled some of the cycle counting stuff out of
arch/arm/kernel/perf_event_v6.c.  I've pushed that code to
the github repo.

git://github.com/spartacus06/zsmapbench.git

My results were in agreement with your findings.  I got 2040
cycles/map for the copy method and 947 cycles/map for the
page-table method.  I think memory speed is playing a big
roll in the difference.

I agree that the page-table method should be restored since
the performance difference is so significant on ARM, a
platform that benefits a lot from memory compression IMHO.

Still, the question remains how to implement the selection
logic, since not all archs that support the page-table
method will necessarily perform better with it.

Thanks,
Seth

