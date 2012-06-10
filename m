Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2FJULH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 16:11:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab2FJULG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 16:11:06 -0400
Date: Sun, 10 Jun 2012 16:10:56 -0400
From: Dave Jones <davej@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: David Rientjes <rientjes@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: oomkillers gone wild.
Message-ID: <20120610201055.GA27662@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
References: <20120604152710.GA1710@redhat.com>
 <alpine.DEB.2.00.1206041629500.7769@chino.kir.corp.google.com>
 <20120605174454.GA23867@redhat.com>
 <alpine.DEB.2.00.1206081313000.19054@chino.kir.corp.google.com>
 <20120608210330.GA21010@redhat.com>
 <alpine.DEB.2.00.1206091920140.7832@chino.kir.corp.google.com>
 <4FD412CB.9060809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD412CB.9060809@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2012 at 11:21:47PM -0400, KOSAKI Motohiro wrote:
 > (6/9/12 10:21 PM), David Rientjes wrote:
 > > On Fri, 8 Jun 2012, Dave Jones wrote:
 > >
 > >>   >  On a system not under oom conditions, i.e. before you start trinity, can
 > >>   >  you send the output of
 > >>   >
 > >>   >  	cat /proc/$(pidof dbus-daemon)/oom_score{_adj,}
 > >>   >  	grep RSS /proc/$(pidof dbus-daemon)/status
 > >>
 > >> # cat /proc/$(pidof dbus-daemon)/oom_score{_adj,}
 > >> -900
 > >> 7441500919753
 > >> # grep RSS /proc/$(pidof dbus-daemon)/status
 > >> VmRSS:	    1660 kB
 > >
 > > I'm suspecting you don't have my patch that changes the type of the
 > > automatic variable in oom_badness() to signed.  Could you retry this with
 > > that patch or pull 3.5-rc2 which already includes it?

that was with the unsigned long -> long patch.

 > Yes. Dave (Jones), As far as parsed your log, you are using x86_64, right?

yes.

 > As far as my testing, current linus tree works fine at least normal case.
 > please respin.

To double check, here it is in rc2 (which has that patch)..

$ uname -r
3.5.0-rc2+
$ cat /proc/$(pidof dbus-daemon)/oom_score{_adj,}
-900
7441500919753
$ grep RSS /proc/$(pidof dbus-daemon)/status
VmRSS:	    1604 kB

