Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab2A1O1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 09:27:19 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46516 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753459Ab2A1O1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 09:27:18 -0500
X-Sasl-enc: 4Z9GLRK/lHm77CgJhWtH5/pT7k7JGrq6YtnxaNzJvMxi 1327760837
Subject: Re: Real time clock update notification
From: Colin Walters <walters@verbum.org>
To: Bob Richmond <bob@lorez.org>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 28 Jan 2012 09:26:54 -0500
In-Reply-To: <4F232AA4.5070208@lorez.org>
References: <4F232AA4.5070208@lorez.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1327760814.5816.1.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 14:52 -0800, Bob Richmond wrote:
> Is there any kind of facility for a process that is blocking in any one 
> of the event notification system calls (select/poll/epoll_wait) to be 
> unblocked in the event that the realtime clock has been updated? For 
> instance, say I want to fire off an event at the exact moment that the 
> realtime clock flips to 2pm. I first query the realtime clock via 
> clock_gettime(CLOCK_REALTIME), and know that in 3 hours, it will be 2pm 
> and I want to unblock at that moment. So I block in epoll_wait for 3 hours.

You're looking for "timerfd".  Our use in GNOME is here:

http://git.gnome.org/browse/gnome-desktop/tree/libgnome-desktop/gnome-datetime-source.c

