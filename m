Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966568Ab0CPRyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:54:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966159Ab0CPRyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:54:22 -0400
Message-ID: <4B9FC557.2060002@redhat.com>
Date: Tue, 16 Mar 2010 13:52:23 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: cl@linux-foundation.org, lee.schermerhorn@hp.com, rientjes@google.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "David S. Miller" <davem@davemloft.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exit: fix oops in sync_mm_rss
References: <20100316170808.GA29400@redhat.com>
In-Reply-To: <20100316170808.GA29400@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 01:08 PM, Michael S. Tsirkin wrote:

> (note: handle_rx_net is a work item using workqueue in question).
> sync_mm_rss+0x33/0x6f gave me a hint. I also tried reverting
> 34e55232e59f7b19050267a05ff1226e5cd122a5 and the oops goes away.
>
> The module in question calls use_mm and later unuse_mm from a kernel
> thread.  It is when this kernel thread is destroyed that the crash
> happens.
>
> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

