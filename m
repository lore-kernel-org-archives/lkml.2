Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab1HNVgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 17:36:17 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:47877 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753910Ab1HNVgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 17:36:16 -0400
Date: Sun, 14 Aug 2011 21:36:42 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>, akpm@linux-foundation.org,
        bonbons@linux-vserver.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
 when reboot
Message-ID: <20110814213642.GB13799@hallyn.com>
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr>
 <20110814161707.GB30846@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110814161707.GB30846@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 08/11, Daniel Lezcano wrote:
> >
> > In the case of a VPS, when we shutdown/halt/reboot the container, the
> > reboot utility will invoke the sys_reboot syscall which has the bad
> > effect to reboot the host.
> 
> Stupid question. Can't sys_reboot() simply kill init (and thus the whole
> pid_ns) in this case?

The goal is to be able to distinguish a request for reboot from shutdown.
If we just kill the init, then the parent of init (the container monitor)
cannot restart the container to emulate reboot.

[ sorry if I misunderstand what you're asking ]

-serge
