Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab0DPDzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 23:55:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57788 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758263Ab0DPDzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 23:55:40 -0400
Message-ID: <4BC7E017.4020002@cn.fujitsu.com>
Date: Fri, 16 Apr 2010 11:57:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Divyesh Shah <dpshah@google.com>
CC: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: lockdep warning on block tree for-2.6.35 branch
References: <4BC7C005.2090100@cn.fujitsu.com> <y2gaf41c7c41004152051w5628eb9fja2159c0eac93cb26@mail.gmail.com>
In-Reply-To: <y2gaf41c7c41004152051w5628eb9fja2159c0eac93cb26@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divyesh Shah :
> Hi Gui,
>     Thanks for the report. I can reproduce this and have a patch that
> fixes it and makes the warning go away. My understanding of what was
> happening is that the stats_lock for the root cfqg was not getting
> initialized and hence was missing the static lock_class_key
> declaration. This is because we call blkio_group_init() only when
> dynamically allocating new cfqg which does not cover the root cfqg.
> I'll send out the patch next.
> 

We just found out the cause and was about to make a fix. :)

-- Li
