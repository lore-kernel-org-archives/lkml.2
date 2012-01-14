Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2ANP5X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 10:57:23 -0500
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:35819 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755060Ab2ANP5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 10:57:21 -0500
Date: Sat, 14 Jan 2012 16:57:13 +0100
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Li Yu <raise.sail@gmail.com>, linux-kernel@vger.kernel.org,
        davidel@xmailserver.org
Subject: Re: The thundering herd like problem when multi epolls on one fd
Message-ID: <20120114155713.GA2966@hell>
References: <4F116350.6090704@gmail.com>
 <1326547247.5287.19.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326547247.5287.19.camel@edumazet-laptop>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Dumazet | 2012-01-14 14:20:47 [+0100]:

>What happens if the awaken thread does not consume the event, and prefer
>to exit ?
>
>If several threads are doing select()/poll()/epoll() on a shared fd,
>they _all_ must be notified the fd is ready, as manpages claim.
>

And if it is intended? Signaled via a new epoll_ctl() epoll_event flag? E.g.
EPOLLEXCLUSIVE

>Doing otherwise would require the prior consent of the user, using a
>special flag for example, and documentation.

Oops, yes. A fanout like mechanism _may be_ superior, but I think tests will
show some improvements anyway.

Hagen
