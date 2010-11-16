Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab0KPSQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:16:25 -0500
Received: from tango.0pointer.de ([85.214.72.216]:35026 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab0KPSQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:16:23 -0500
Date: Tue, 16 Nov 2010 19:16:03 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116181603.GC19327@tango.0pointer.de>
References: <1289820766.16406.45.camel@maggy.simson.net>
 <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com>
 <1289856350.14719.135.camel@maggy.simson.net>
 <20101116015648.GA11534@redhat.com>
 <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 09:11, Linus Torvalds (torvalds@linux-foundation.org) wrote:

> 
> On Tue, Nov 16, 2010 at 9:03 AM, Lennart Poettering
> <mzxreary@0pointer.de> wrote:
> >
> > Binding something like this to TTYs is just backwards.
> 
> Numbers talk, bullshit walks.
> 
> The numbers have been quoted. The clear interactive behavior has been seen.

Here's my super-complex patch btw, to achieve exactly the same thing
from userspace without involving any kernel or systemd patching and
kernel-side logic. Simply edit your own ~/.bashrc and add this to the end:

  if [ "$PS1" ] ; then  
          mkdir -m 0700 /sys/fs/cgroup/cpu/user/$$
          echo $$ > /sys/fs/cgroup/cpu/user/$$/tasks
  fi

Then, as the superuser do this:

  mount -t cgroup cgroup /sys/fs/cgroup/cpu -o cpu
  mkdir -m 0777 /sys/fs/cgroup/cpu/user

Done. Same effect. However: not crazy.

I am not sure I myself will find the time to prep some 'numbers' for
you. They'd be the same as with the kernel patch anyway. But I am sure
somebody else will do it for you...

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
