Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab2G3IFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 04:05:42 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:60982 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab2G3IFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 04:05:39 -0400
Date: Mon, 30 Jul 2012 10:05:36 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [Bisected] commit 71574865 (vfs: do_last(): common slow lookup)
 breaks CUPS printing
Message-ID: <20120730080536.GA268@x4>
References: <20120728104316.GA248@x4>
 <20120730065046.GC6481@ZenIV.linux.org.uk>
 <20120730071023.GA273@x4>
 <20120730075611.GD6481@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120730075611.GD6481@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.07.30 at 08:56 +0100, Al Viro wrote:
> On Mon, Jul 30, 2012 at 09:10:23AM +0200, Markus Trippelsdorf wrote:
> > 
> > Looks like you're right. The first warning happens during startup. The last one
> > when I print a test page (which now succeeds).  
> > Thanks Al.
> 
> > WTF: open("/dev/input/mice", 34946)
> > WTF: open("/dev/usblp0", 32898)
> > WTF: open("/dev/usb/lp0", 32898)
> 
> Ahhh...  OK, yes - it's the case we had missed (and where the manpage
> needs correction, BTW).  O_EXCL for *devices* has additional semantics;
> it's not "fail if exists", it's "fail if already opened by somebody".
> No need to pester CUPS folks (except that I really hope that this
> open of /dev/input/mice does *not* come from them)...

I've omitted some WTF's from my former reply, because they happend after
I've sent it.

Jul 30 09:06:51 x4 kernel: ------------[ cut here ]------------
Jul 30 09:06:51 x4 kernel: WARNING: at fs/open.c:899 do_sys_open+0x1e5/0x220()
Jul 30 09:06:51 x4 kernel: Hardware name: System Product Name
Jul 30 09:06:51 x4 kernel: Pid: 87, comm: cupsd Tainted: G        W    3.5.0-07078-gf7da9cd-dirty #199
Jul 30 09:06:51 x4 kernel: Call Trace:
Jul 30 09:06:51 x4 kernel: WTF: open("/dev/usb/lp0", 32898)
Jul 30 09:06:51 x4 kernel: [<ffffffff810555a4>] ? warn_slowpath_common+0x74/0xb0
Jul 30 09:06:51 x4 kernel: [<ffffffff810dd405>] ? do_sys_open+0x1e5/0x220
Jul 30 09:06:51 x4 kernel: [<ffffffff814a64a2>] ? system_call_fastpath+0x16/0x1b
Jul 30 09:06:51 x4 kernel: ---[ end trace 9a333bfb6a9cbe83 ]---
Jul 30 09:07:19 x4 kernel: WTF: open("/var/spool/cups/a00018", 32897)
Jul 30 09:07:19 x4 kernel: ------------[ cut here ]------------
Jul 30 09:07:19 x4 kernel: WARNING: at fs/open.c:899 do_sys_open+0x1e5/0x220()
Jul 30 09:07:19 x4 kernel: Hardware name: System Product Name
Jul 30 09:07:19 x4 kernel: Pid: 87, comm: cupsd Tainted: G        W    3.5.0-07078-gf7da9cd-dirty #199
Jul 30 09:07:19 x4 kernel: Call Trace:
Jul 30 09:07:19 x4 kernel: [<ffffffff810555a4>] ? warn_slowpath_common+0x74/0xb0
Jul 30 09:07:19 x4 kernel: [<ffffffff810dd405>] ? do_sys_open+0x1e5/0x220
Jul 30 09:07:19 x4 kernel: [<ffffffff814a64a2>] ? system_call_fastpath+0x16/0x1b
Jul 30 09:07:19 x4 kernel: ---[ end trace 9a333bfb6a9cbe84 ]---
Jul 30 09:30:40 x4 kernel: WTF: open("/var/cache/cups/job.cache.O", 32897)
Jul 30 09:30:40 x4 kernel: ------------[ cut here ]------------
Jul 30 09:30:40 x4 kernel: WARNING: at fs/open.c:899 do_sys_open+0x1e5/0x220()
Jul 30 09:30:40 x4 kernel: Hardware name: System Product Name
Jul 30 09:30:40 x4 kernel: Pid: 87, comm: cupsd Tainted: G        W    3.5.0-07078-gf7da9cd-dirty #199
Jul 30 09:30:40 x4 kernel: Call Trace:
Jul 30 09:30:40 x4 kernel: [<ffffffff810555a4>] ? warn_slowpath_common+0x74/0xb0
Jul 30 09:30:40 x4 kernel: [<ffffffff810dd405>] ? do_sys_open+0x1e5/0x220
Jul 30 09:30:40 x4 kernel: [<ffffffff814a64a2>] ? system_call_fastpath+0x16/0x1b
Jul 30 09:30:40 x4 kernel: ---[ end trace 9a333bfb6a9cbe85 ]---

/var/spool/cups/a00018 & /var/cache/cups/job.cache.O are not devices AFAICS.

-- 
Markus
