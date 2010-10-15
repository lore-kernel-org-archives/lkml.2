Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab0JOQXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:23:39 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:52079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab0JOQXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:23:38 -0400
From: Johannes Berg <johannes@sipsolutions.net>
Reply-To: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.36-rc7] mac80211: cancel restart_work explicitly
	instead of depending on flush_scheduled_work()
X-Mailer: Modest 3.2
References: <4CB874C0.8090003@kernel.org>
In-Reply-To: <4CB874C0.8090003@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-ID: <1287159714.1870.10.camel@Nokia-N900-51-1>
Date: Fri, 15 Oct 2010 18:21:55 +0200
Message-Id: <1287159715.1870.11.camel@Nokia-N900-51-1>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -        create_singlethread_workqueue(wiphy_name(local->hw.wiphy));
> +        alloc_ordered_workqueue(wiphy_name(local->hw.wiphy), 0);

no description for this change?

> -    /*
> -     * For key todo, it'll be empty by now but the work
> -     * might still be scheduled.
> -     */
> -    flush_scheduled_work();

oops, todo work no longer exists...

Anyway, ACK.

Johannes
(sent on my cell phone)
