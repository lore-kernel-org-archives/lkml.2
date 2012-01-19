Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab2ASQbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:31:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40322 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab2ASQbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:31:05 -0500
Date: Thu, 19 Jan 2012 08:30:56 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] blkcg: kill the mind-bending blkg->dev
Message-ID: <20120119163056.GH5198@google.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-13-git-send-email-tj@kernel.org>
 <20120119154919.GA10908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119154919.GA10908@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 19, 2012 at 10:49:19AM -0500, Vivek Goyal wrote:
> > Let stat and conf read functions get device name from
> > blkg->q->backing_dev_info.dev and pass it down to printing functions
> > and remove blkg->dev.
> 
> I think one of the reasons for not using blkg->q->backing_dev_info.dev was
> that there were still drivers where multiple gendisks were sharing the
> request queue.

Hmmm... is that relevant?  The configurations / stats are per
cgroup-request_queue pair.  How does multiple genhd's sharing a queue
make any difference?  Also, the fill_dev_details functions were using
the same q->backing_dev_info to fill it in, so it's not like it was
using anything different.

Thanks.

-- 
tejun
