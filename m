Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1LQVri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 16:47:38 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:19350 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1LQVrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 16:47:35 -0500
Date: Sat, 17 Dec 2011 16:46:26 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ferenc Wagner <wferi@niif.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        linux-x86_64@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH] cpu idle ticks show twice in xen pvm guest
Message-ID: <20111217214626.GA17841@phenom.dumpdata.com>
References: <ce19ea02-45e6-465a-a4c8-b5d74bf8c2ad@default>
 <20111010155319.GA29140@phenom.oracle.com>
 <4E934EC9.5030909@goop.org>
 <87vcppbvc4.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vcppbvc4.fsf@tac.ki.iif.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4EED0DF0.0086,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 04:47:39PM +0100, Ferenc Wagner wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
> 
> >> On Wed, Oct 05, 2011 at 10:11:58PM -0700, Zhenzhong Duan wrote:
> >>
> >>> Run below test on xen pvm.
> >>> # x=$(cat /proc/stat | grep cpu0 | awk '{print $5}') && sleep 60  \
> >>> && y=$(cat /proc/stat | grep cpu0 | awk '{print $5}') \
> >>> && echo -e  "X:$x\nY:$y\nIDLE:" $(echo "scale=3; ($y-$x)/6000*100" | bc)
> >>>
> >>> @ X:58562301
> >>> @ Y:58574282
> >>> @ IDLE: 199.600
> >>>
> >>> Normal idle percent should be around 100%.
> >>> xen_timer_interrupt called account_idle_ticks to account hypervisor stolen idle ticks 
> >>> but these ticks will be accounted again when idle ticks restarted.
> >>>
> >>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> >>> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> >
> > Does this affect the accounting of stolen ticks?  If it does, that's not
> > necessarily a showstopper for this patch, but we'll need to do some more
> > thinking about it.  Certainly, accurate accounting for idleness is
> > important.
> 
> Please see also http://thread.gmane.org/gmane.linux.kernel/734441, where
> I found that the counter doubling isn't always present under 2.6.26.
> However, after going to 2.6.32 (Debian lenny-backports kernel, 4th of
> April on the graph below) that instability seems to disappear.  Please
> note that the following graph shows halved idle and iowait percentages.
> 

What happenend in Feb?

> 
> (I haven't collected steal values, so the numbers don't sum up to 100%.)
> I'd be grateful if this discrepancy could be cleared up eventually!
> It's heartening to see some progress after more than three years. :)
> 
> Actually, as Munin doesn't half the idle and iowait values, but
> truncates the (then overflowing) graph at 100%, I was rather surprised
> to see iowait completely disappear after the kernel upgrade, and
> concluded that it was somehow converted into buggy-looping in blkfront.
> Now I see this isn't the case, but the steadily increasing system CPU
> usage between reboots is still a mystery.  I'll start a separate thread
> for that, just wanted to provide some motivation for this topic.

Did you add more memory in the system?
> --
> Thanks,
> Feri.

