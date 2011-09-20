Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1ITJVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 05:21:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:53169 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab1ITJVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 05:21:54 -0400
Subject: Re: [PATCH 6/9] Include idle and iowait fields in cpuacct
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, mingo@elte.hu,
        jbottomley@parallels.com
Date: Tue, 20 Sep 2011 11:21:30 +0200
In-Reply-To: <1316030695-19826-7-git-send-email-glommer@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	 <1316030695-19826-7-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316510490.11841.15.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
> These are slightly different from the others though:
> (note to reviewers: might be better to put those in a separate
> array?)
> 
> Since idle/iowait are a property of the system - by definition,
> no process from any cgroup is running when the system is idle,
> they are system wide. So what these fields really mean, are baselines
> for when the cgroup was created. It allows the cgroup to start
> counting idle/iowait from 0.

Alternatively you can make iowait based on nr_uninterruptible per cgroup
and count all ticks _this_ cgroup was idle.

Now all that would need moar accounting...
