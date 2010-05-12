Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab0ELVGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:06:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48742 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab0ELVGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:06:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Valdis.Kletnieks@vt.edu
Subject: Re: mmotm 2010-05-11 - dies in pm_qos_update_request()
Date: Wed, 12 May 2010 23:07:20 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
References: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org> <5525.1273693962@localhost>
In-Reply-To: <5525.1273693962@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201005122307.20860.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 May 2010, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 11 May 2010 18:21:22 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-05-11-18-20 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Dell Latitude E6500, x86_64 kernel.
> 
> Died a horrid death at boot in the e1000e driver.  Seems to be
> something in linux-next.patch. Didn't get a netconsole trace for obvious
> reasons...
> 
> Copied-by-hand traceback:
> pm_qos_update_request()+0x22
> e1000_configure+0x478
> e1000_open_device+0xee
> ? _raw_notifier_call_chain+0xf
> __dev_open+0xec
> dev_open+0x1b
> netpoll_setup+0x28b
> init_netconsole+0xbc
> 
> I suspect this commit:
> 
> commit 23606cf5d1192c2b17912cb2ef6e62f9b11de133
> Author: Rafael J. Wysocki <rjw@sisk.pl>
> Date:   Sun Mar 14 14:35:17 2010 +0000
> 
>     e1000e / PCI / PM: Add basic runtime PM support (rev. 4)

No, I don't think so.  I'm running -rc6 with this patch applied on a box with
e1000e and it works just fine.

Please try to revert this one instead:

http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-2.6.git;a=patch;h=ed77134bfccf5e75b6cbadab268e559dbe6a4ebb

Rafael
