Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1FUHes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:34:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51042 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab1FUHer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:34:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Jun 2011 16:27:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Rolland (=?ISO-2022-JP?B?GyRCJV0hPCVrISYlbSVpJXMbKEI=?=) 
	<rol@witbe.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc4 - fail to compile...
Message-Id: <20110621162739.ff1936d9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110621091335.49bc46df@tux.DEF.witbe.net>
References: <BANLkTimiVpKavmKY=rsJP34dMQSq__Xn7g@mail.gmail.com>
	<20110621091335.49bc46df@tux.DEF.witbe.net>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011 09:13:35 +0200
Paul Rolland (ポール・ロラン)  <rol@witbe.net> wrote:

> Hello,
> 
> On Mon, 20 Jun 2011 21:02:56 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Mostly the usual small driver one- (or few-) liners, and some bigger
> > changes to drm (and md). But also two new smallish drivers
> > (net/usb/kalmia.c, and the ADP8870 backlight driver). Some filesystem
> > fixes (btrfs, cifs, afs, xfs, nfsd).
> 
> This is failing to compile on my machine :
> ...
>   CC      mm/page_cgroup.o
>   CC      fs/direct-io.o
> mm/page_cgroup.c: In function ‘page_cgroup_init’:
> mm/page_cgroup.c:308: error: implicit declaration of function ‘node_start_pfn’
> mm/page_cgroup.c:309: error: implicit declaration of function ‘node_end_pfn’
> make[1]: *** [mm/page_cgroup.o] Error 1
> make: *** [mm] Error 2
> make: *** Waiting for unfinished jobs....
>   CC      fs/mpage.o
>   CC      fs/ioprio.o
> 
> This seems to be caused by arch/x86/include/asm/mmzone_64.h which only defines
> node_start_pfn and node_end_pfn if CONFIG_NUMA is set.
> 
> Adding CONFIG_NUMA to my .config fixes the issue.


Sorry, now patch is queued into mmotm.

This patch : http://marc.info/?l=linux-mm-commits&m=130834703319994&w=2

Thanks,
-Kame


