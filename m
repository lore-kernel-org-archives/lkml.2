Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab0JRIRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 04:17:39 -0400
Received: from [120.204.251.227] ([120.204.251.227]:35272 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751935Ab0JRIRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 04:17:38 -0400
Subject: Re: oom_killer crash linux system
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        figo1802 <figo1802@gmail.com>
In-Reply-To: <20101018021126.GB8654@localhost>
References: <1287366459.2035.1.camel@myhost>
	 <20101018105722.03415e48.kamezawa.hiroyu@jp.fujitsu.com>
	 <20101018021126.GB8654@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 16:13:51 +0800
Message-ID: <1287389631.1997.9.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Oct 2010 08:17:31.0781 (UTC) FILETIME=[E945CB50:01CB6E9C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i want to test the oom-killer. My desktop (Dell optiplex 780, i686
kernel)have 2GB ram, i turn off the swap partition, and open a huge pdf
files and applications, and let the system eat huge ram.

in 2.6.35, i can use ram up to 1.75GB,

but in 2.6.36-rc8, i just use to 1.53GB ram , the system come very slow
and crashed after some minutes , the DiskIO is very busy. i see the
DiskIO read is up to 8MB/s, write just only 400KB/s, (see by conky).

what change between 2.6.35 to 2.6.36-rc8? is it low performance about
page reclaim and page writeback in high press ram useage?

Best,
Figo.zhang




On Mon, 2010-10-18 at 10:11 +0800, Wu Fengguang wrote:
> On Mon, Oct 18, 2010 at 09:57:22AM +0800, KAMEZAWA Hiroyuki wrote:
> > On Mon, 18 Oct 2010 09:47:39 +0800
> > "Figo.zhang" <zhangtianfei@leadcoretech.com> wrote:
> > 
> > > hi all,
> > > 
> > > i have a desktop run linux2.6.35 and have 2GB ram. i turn off the swap
> > > partition, and i open huge applications , let the system eat more and
> > > more memory.
> > > when the system eat more than 1.7G ram, the system crashed.
> > > 
> > 
> > 2.6.36-rc series has a completely new logic, please try.
> 
> And the new logic should help this case.
> 
> commit a63d83f427fbce97a6cea0db2e64b0eb8435cd10
> Author: David Rientjes <rientjes@google.com>
> Date:   Mon Aug 9 17:19:46 2010 -0700
> 
>     oom: badness heuristic rewrite
> ...
>     Instead of basing the heuristic on mm->total_vm for each task, the task's
>     rss and swap space is used instead.  This is a better indication of the
>     amount of memory that will be freeable if the oom killed task is chosen
>     and subsequently exits.  This helps specifically in cases where KDE or
>     GNOME is chosen for oom kill on desktop systems instead of a memory
>     hogging task.
> ...
> 
> Thanks,
> Fengguang


