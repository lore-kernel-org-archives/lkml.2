Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab0J1DK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 23:10:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42600 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833Ab0J1DK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 23:10:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 28 Oct 2010 12:05:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Pawan Singh <pawan@pinger.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Tweaking swap algorithm under constrained memory usage
Message-Id: <20101028120532.bf48b3f0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTikRCiX3dY3-iSXKX8YhQUZp=qoM7wm0cFnxq8NP@mail.gmail.com>
References: <AANLkTimCSGoeRHXWS2Y5=THbOkHUfY71=B6JzOeFz_=X@mail.gmail.com>
	<20101028095258.c778a223.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikRCiX3dY3-iSXKX8YhQUZp=qoM7wm0cFnxq8NP@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010 19:58:00 -0700
Pawan Singh <pawan@pinger.org> wrote:

> >
> > Recent kernel (2.6.28-) has splited LRUs as
> >  - active/inactive ANON
> >  - active/inactive FILE
> >  - LOCKED (UNEVICTABLE) ---(new)
> 
> Thanks for the reply. Does that mean that in 2.6.28 kernel, kswapd
> will modify its thresholds so that it only looks at active/inactive
> ANON?
> 

kswapd's threshold is not modifled. But because UNEVICTABLE LRU is not
scanned by kswapd, time consumption of kswapd is dramatically reduced.

About kswapd trigger, IIUC, /proc/sys/vm/min_free_kbytes is one.

Thanks,
-Kame

