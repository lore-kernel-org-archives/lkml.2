Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab1BIDNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 22:13:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55904 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755500Ab1BIDNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 22:13:13 -0500
Message-ID: <4D520646.7040001@cn.fujitsu.com>
Date: Wed, 09 Feb 2011 11:13:10 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: jaxboe@fusionio.com, vgoyal@redhat.com, ctalbott@google.com,
        mrubin@google.com, jmoyer@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Don't wait if queue already has requests.
References: <1297192697-29978-1-git-send-email-teravest@google.com>
In-Reply-To: <1297192697-29978-1-git-send-email-teravest@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-09 11:12:19,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-09 11:12:22,
	Serialize complete at 2011-02-09 11:12:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin TerAvest wrote:
> Commit 7667aa0630407bc07dc38dcc79d29cc0a65553c1 added logic to wait for
> the last queue of the group to become busy (have at least one request),
> so that the group does not lose out for not being continuously
> backlogged. The commit did not check for the condition that the last
> queue already has some requests. As a result, if the queue already has
> requests, wait_busy is set. Later on, cfq_select_queue() checks the
> flag, and decides that since the queue has a request now and wait_busy
> is set, the queue is expired.  This results in early expiration of the
> queue.
> 
> This patch fixes the problem by adding a check to see if queue already
> has requests. If it does, wait_busy is not set. As a result, time slices
> do not expire early.
> 
> The queues with more than one request are usually buffered writers.
> Testing shows improvement in isolation between buffered writers.
> 
> Signed-off-by: Justin TerAvest <teravest@google.com>

This patch looks good to me.

Reviewed-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Thanks,
Gui
