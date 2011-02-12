Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415Ab1BLDNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 22:13:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59098 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758252Ab1BLDNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 22:13:08 -0500
Message-ID: <4D55FAC1.9070208@cn.fujitsu.com>
Date: Sat, 12 Feb 2011 11:13:05 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: jaxboe@fusionio.com, vgoyal@redhat.com, ctalbott@google.com,
        mrubin@google.com, jmoyer@redhat.com, guijanfeng@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Don't update group weights when on service tree.
References: <1297372086-16138-1-git-send-email-teravest@google.com>
In-Reply-To: <1297372086-16138-1-git-send-email-teravest@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-12 11:12:14,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-12 11:12:14,
	Serialize complete at 2011-02-12 11:12:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin TerAvest wrote:
> With some instrumentation, we can observe that the total_weight for a 
> service tree can be badly adjusted; particularly when the weight for a 
> group is adjusted without taking it off of the tree. This can be 
> reproduced on the HEAD of the linux-2.6-block tree.
> 
> We have seen this problem in workloads when total_weight becomes 0 and 
> we divide by 0 in cfq_group_slice(), crashing the kernel, but it's
> easier to illustrate by adding a BUG_ON and making it signed, like this:

Justin,

I have also catch this BUG by browsing code a few days ago. ;)

The problem is we don't update st->total_weight when we setting a new weight
for a group.

Thanks,
Gui

