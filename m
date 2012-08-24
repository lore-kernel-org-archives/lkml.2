Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632Ab2HXU6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:58:03 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46018 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933376Ab2HXU57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:57:59 -0400
Message-ID: <5037EAC8.6080403@linux.vnet.ibm.com>
Date: Fri, 24 Aug 2012 15:57:44 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] revert changes to zcache_do_preload()
References: <1345735991-6995-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120823205648.GA2066@barrios> <5036AA38.6010400@linux.vnet.ibm.com> <20120823232845.GE5369@bbox>
In-Reply-To: <20120823232845.GE5369@bbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082420-2356-0000-0000-000001922A59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 06:28 PM, Minchan Kim wrote:
> Okay, then, why do you think the patchsets are culprit?
> I didn't look the cleanup patch series of Xiao at that time
> so I can be wrong but as I just look through patch of
> "zcache: optimize zcache_do_preload", I can't find any fault
> because zcache_put_page checks irq_disable so we don't need
> to disable preemption so it seems that patch is correct to me.
> If the race happens by preemption, BUG_ON in zcache_put_page
> should catch it.
> 
> What do you mean? Do you have any clue in your mind?
> 
>         The commits undermine an assumption made by tmem_put() in
>         the cleancache path that preemption is disabled.

I do not have an explanation right now for why these commits
expose this issue.  The patch looks like it should be fine
to me, hence my Ack at the time.

I understand and agree with you that the zcache shim
functions zcache_put_page(), zcache_get_page(),
zcache_flush_page(), and zcache_flush_object() all disable
interrupts (or make sure that interrupts are already
disabled) which implicitly disables preemption.

I'm still trying to find root cause here.

Seth

