Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2ETMSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 08:18:11 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:55188 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab2ETMSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 08:18:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [-next regression] TCP window full with EPOLLWAKEUP
Date: Sun, 20 May 2012 14:23:08 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        NeilBrown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <4FB81981.3050509@suse.cz>
In-Reply-To: <4FB81981.3050509@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205201423.08334.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 20, 2012, Jiri Slaby wrote:
> Hi,
> 
> a bisection shows that with the following commit from -next:
> commit 4d7e30d98939a0340022ccd49325a3d70f7e0238
> Author: Arve Hjønnevåg <arve@android.com>
> Date:   Tue May 1 21:33:34 2012 +0200
> 
>     epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while epoll
> events are ready
> 
> ====
> 
> one of mono programs I use stops receiving data from the network.
> Wireshark shows that the TCP window of a connection is filled. This
> means the program does not read the data fast enough after requesting
> the data.
> 
> If I revert that commit on the top of -next (20120518), everything works
> as expected.

Hmm.  I suppose that the failing program doesn't set EPOLLWAKEUP by mistake,
does it?

Rafael
