Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab2ESWHE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 18:07:04 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65074 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2ESWHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 18:07:02 -0400
Message-ID: <4FB81981.3050509@suse.cz>
Date: Sun, 20 May 2012 00:06:57 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120514 Thunderbird/14.0a2
MIME-Version: 1.0
To: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
CC: NeilBrown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [-next regression] TCP window full with EPOLLWAKEUP
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

a bisection shows that with the following commit from -next:
commit 4d7e30d98939a0340022ccd49325a3d70f7e0238
Author: Arve Hjønnevåg <arve@android.com>
Date:   Tue May 1 21:33:34 2012 +0200

    epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while epoll
events are ready

====

one of mono programs I use stops receiving data from the network.
Wireshark shows that the TCP window of a connection is filled. This
means the program does not read the data fast enough after requesting
the data.

If I revert that commit on the top of -next (20120518), everything works
as expected.

regards,
-- 
js
suse labs

