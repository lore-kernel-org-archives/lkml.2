Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab1LIJys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 04:54:48 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:53874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab1LIJyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 04:54:47 -0500
Subject: workqueue_set_max_active(wq, 0)?
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Dec 2011 10:54:42 +0100
Message-ID: <1323424482.3622.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I know workqueue_set_max_active(wq, 0) isn't allowed, but I was just
playing with making mac80211 completely synchronous in the configuration
path. (The reason is that right now, we have a single-threaded workqueue
and configuration entry points, so it's *almost* single-threaded /
synchronous. This means that the non-synchronous nature rarely gets
tested.)

So I thought I could put a work struct onto the workqueue and then when
it executes it signals the configuration function & waits for that to
finish, etc., a bit like the rendezvous mechanism used to flush works.

But then I thought maybe this should be more generic, like
"workqueue_pause()" / "workqueue_resume()".

And then I found workqueue_set_max_active() but passing 0 isn't allowed.

Before I dive in more deeply I figured I'd ask if you think what a good
way of doing this would be (and whether I'm completely insane) :-)

johannes

