Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab2EGULn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:11:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757621Ab2EGULm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:11:42 -0400
Message-ID: <4FA82C6B.4010801@redhat.com>
Date: Mon, 07 May 2012 16:11:23 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Satoru Moriya <satoru.moriya@hds.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [RFC][PATCH] avoid swapping out with swappiness==0
References: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com>
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 12:36 PM, Satoru Moriya wrote:
> Sometimes we'd like to avoid swapping out anonymous memory
> in particular, avoid swapping out pages of important process or
> process groups while there is a reasonable amount of pagecache
> on RAM so that we can satisfy our customers' requirements.
>
> OTOH, we can control how aggressive the kernel will swap memory pages
> with /proc/sys/vm/swappiness for global and
> /sys/fs/cgroup/memory/memory.swappiness for each memcg.
>
> But with current reclaim implementation, the kernel may swap out
> even if we set swappiness==0 and there is pagecache on RAM.
>
> This patch changes the behavior with swappiness==0. If we set
> swappiness==0, the kernel does not swap out completely
> (for global reclaim until the amount of free pages and filebacked
> pages in a zone has been reduced to something very very small
> (nr_free + nr_filebacked<  high watermark)).

> Signed-off-by: Satoru Moriya<satoru.moriya@hds.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
