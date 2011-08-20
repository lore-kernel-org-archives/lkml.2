Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1HTLDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 07:03:50 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:33307 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1HTLDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 07:03:48 -0400
Date: Sat, 20 Aug 2011 13:03:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LXC Development <Lxc-devel@lists.sourceforge.net>
Subject: Re: [RFC] catching sys_reboot syscall
Message-ID: <20110820110308.GA1906@ucw.cz>
References: <4E4051A0.8030009@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4051A0.8030009@free.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> In this case, the container shutdowns correctly but, at the end, the
> init process is waiting indefinitely and we have the containers stuck
> with one process (the init process).
> 
> In order to fix that, we used a hypervisor process, parent of the
> container's init process, watching for the container's utmp file and
> detecting when the runlevel changes. When this runlevel change is
> detected we wait for the container to have one process left and then we
> kill the container's init.
> 
> That works well if we modify the distro configuration files, we make
> /var/run to not be a tmpfs and we remove all the files inside this
> directory when the container boots. *But* as soon as we upgrade the
> container distro, all the tweaks are lost. So this method works but at
> the cost of tweaking the containers configuration files again and again,
> each time there is an update, which is not tolerable in a production
> environment.
> 
> This problem is easy to solve with a small hack in the kernel:

Hmm. If you just made sys_reboot() equivalent to exit() for container
case... perhaps patch would be even simpler..?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
