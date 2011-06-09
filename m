Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1FIAok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 20:44:40 -0400
Received: from science.horizon.com ([71.41.210.146]:40700 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751215Ab1FIAoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 20:44:37 -0400
Date: 8 Jun 2011 20:44:35 -0400
Message-ID: <20110609004435.14550.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: david@rgmadvisors.com, dvhart@linux.intel.com, kyle@moffetthome.net,
        luto@mit.edu
Subject: Re: Change in functionality of futex() system call.
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure if it's best, but the risk of RO waiters interfering could
be solved by giving them a lower prioirty for wakeup and always waking
RW-mapped waiters first.

In most cases, there would only be one type of waiter, so this would
have no effect, but if there were, a RO-mapped reader couldn't "steal"
wakeup from someone who had it RW-mapped.

It might conflict with a fairness goal, but it does solve the problem
without any extension to the API.
