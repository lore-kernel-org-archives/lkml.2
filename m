Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab2J1NM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 09:12:57 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:55080 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752223Ab2J1NM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 09:12:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18aHngU+Aoa5kDpCAeDvlhhp04ZLl6bf6i90rpc7u
	BInsPOFCB6lpUj
Message-ID: <1351430004.8685.17.camel@maggy.simpson.net>
Subject: Re: [PATCH] sched, autogroup: fix crash on reboot when autogroup is
 disabled
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Xiaotian Feng <xtfeng@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Sun, 28 Oct 2012 06:13:24 -0700
In-Reply-To: <20121028102520.GA7711@gmail.com>
References: <1350635770-9189-1-git-send-email-xtfeng@gmail.com>
	 <1350654126.2768.5.camel@twins>
	 <CAJn8CcE5McFB-FH981Pj+eahNOt8ck3ncJwD4xocU_LrAtjBHA@mail.gmail.com>
	 <1350736696.5123.24.camel@maggy.simpson.net>
	 <1351283371.16639.111.camel@maggy.simpson.net>
	 <1351362370.4503.3.camel@maggy.simpson.net>
	 <20121028102520.GA7711@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-28 at 11:25 +0100, Ingo Molnar wrote: 
> * Mike Galbraith <efault@gmx.de> wrote:
> 

> > No knobs, no glitz, nada, just a cute little thing folks can turn
> > on if they don't want to muck about with cgroups and/or systemd.
> 
> Please also keep the Kconfig switch and reuse it to turn on the 
> 'autogroups' knob.
> 
> That way people with existing .config's don't have to change a 
> thing to get this functionality.

The Kconfig option is still there.  The noautogroup -> autogroup arg
change just makes it off by default (since an on/off switch would have
to be a full move everybody thing post 8323f26ce race fix), so distros
can make it available in their swiss army knife config, but it'll be out
of the way unless specifically asked for by the user at boot.

I can make it default 'on' by removing that arg change if you think
that's the better way to go, but opt in at boot sounded better to me
given there is no runtime on/off switch at all now.

-Mike

