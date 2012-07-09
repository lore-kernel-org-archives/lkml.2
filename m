Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab2GIMxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:53:39 -0400
Received: from plane.gmane.org ([80.91.229.3]:56339 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab2GIMxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:53:38 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] mm: Warn about costly page allocation
Date: Mon, 9 Jul 2012 12:53:22 +0000 (UTC)
Message-ID: <jtek81$ja5$1@dough.gmane.org>
References: <1341801500-5798-1-git-send-email-minchan@kernel.org>
 <20120709082200.GX14154@suse.de> <20120709084657.GA7915@bbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 112.132.204.44
User-Agent: slrn/0.9.9p1 (Linux)
Cc: linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jul 2012 at 08:46 GMT, Minchan Kim <minchan@kernel.org> wrote:
>> 
>> WARN_ON_ONCE would tell you what is trying to satisfy the allocation.
>
> Do you mean that it would be better to use WARN_ON_ONCE rather than raw printk?
> If so, I would like to insist raw printk because WARN_ON_ONCE could be disabled
> by !CONFIG_BUG.
> If I miss something, could you elaborate it more?
>

Raw printk could be disabled by !CONFIG_PRINTK too, and given that:

config PRINTK
        default y
        bool "Enable support for printk" if EXPERT
		    
config BUG
        bool "BUG() support" if EXPERT
        default y

they are both configurable only when ERPERT, so we don't need to
worry much. :)

