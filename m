Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab2IHSLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 14:11:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52739 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2IHSLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 14:11:11 -0400
Date: Sat, 8 Sep 2012 11:11:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7 V6] workqueue: fix idle worker depletion
Message-ID: <20120908181107.GJ10788@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
 <1347124383-18723-5-git-send-email-laijs@cn.fujitsu.com>
 <20120908174044.GD10788@dhcp-172-17-108-109.mtv.corp.google.com>
 <CACvQF53dj+fVdYf6uSPREGbtLTBvLcaqX1CJN6XVQOCPx3ttsA@mail.gmail.com>
 <20120908175354.GH10788@dhcp-172-17-108-109.mtv.corp.google.com>
 <CACvQF51edrK2LhPbEk6890uxANnLQGp8E2LsTi+dZGgn24y_zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF51edrK2LhPbEk6890uxANnLQGp8E2LsTi+dZGgn24y_zw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2012 at 02:07:50AM +0800, Lai Jiangshan wrote:
> when we release gcwq->lock and then grab it, we leave a hole that things
> can be changed.
> 
> I don't want to open a hole. if the hole has bug we have to fix it.
> if the hole has no bug, we have to add lot of comments to explain it.
> 
> When I write this reply. I am thinking: is the hole  has bug if
> I release gcwq->lock here? result: no. But I don't want to add all things
> what I have thought as comments to explain there is no bug even when we
> open a hole. don't leave reviewers too much burden.

We're already releasing gcwq->lock in maybe_create_worker().  That's
the reason why @ret is set to true.  In addition, we already released
the lock to grab manager_mutex.  So, you're not adding any burden.
Please reuse the busy rebinding mechanism.

Thanks.

-- 
tejun
