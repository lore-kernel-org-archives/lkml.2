Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0LJTHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 14:07:31 -0500
Received: from science.horizon.com ([71.41.210.146]:24943 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756383Ab0LJTHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 14:07:30 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Dec 2010 14:07:30 EST
Date: 10 Dec 2010 14:00:47 -0500
Message-ID: <20101210190047.11069.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 1/6] mlock: only hold mmap_sem in shared mode when
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about (bugfixed):

bool cond_break_mutex(struct mutex *mutex)
{
	if (!mutex_is_contended(mutex))
		return false;
	mutex_unlock(mutex);
	mutex_lock(mutex);
	return true;
}

It would be possible to share work between the unlock and lock slowpaths
(particularly the wait_lock acquisition), but that's probably more
maintenance effort than it's worth.
