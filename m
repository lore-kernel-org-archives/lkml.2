Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964880Ab2FHVDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 17:03:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964860Ab2FHVDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 17:03:36 -0400
Date: Fri, 8 Jun 2012 17:03:30 -0400
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: oomkillers gone wild.
Message-ID: <20120608210330.GA21010@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
References: <20120604152710.GA1710@redhat.com>
 <alpine.DEB.2.00.1206041629500.7769@chino.kir.corp.google.com>
 <20120605174454.GA23867@redhat.com>
 <alpine.DEB.2.00.1206081313000.19054@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206081313000.19054@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 01:15:50PM -0700, David Rientjes wrote:
 > On Tue, 5 Jun 2012, Dave Jones wrote:
 > 
 > > Still doesn't seem right..
 > > 
 > > eg..
 > > 
 > > [42309.542776] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
 > > ..
 > > [42309.553933] [  500]    81   500     5435        1   4     -13          -900 dbus-daemon
 > > ..
 > > [42309.597531] [ 9054]  1000  9054   528677    14540   3       0             0 trinity-child3
 > > ..
 > > 
 > > [42309.643057] Out of memory: Kill process 500 (dbus-daemon) score 511952 or sacrifice child
 > > [42309.643620] Killed process 500 (dbus-daemon) total-vm:21740kB, anon-rss:0kB, file-rss:4kB
 > > 
 > > and a slew of similar 'wrong process' death spiral kills follows..
 > > 
 > 
 > On a system not under oom conditions, i.e. before you start trinity, can 
 > you send the output of
 > 
 > 	cat /proc/$(pidof dbus-daemon)/oom_score{_adj,}
 > 	grep RSS /proc/$(pidof dbus-daemon)/status

# cat /proc/$(pidof dbus-daemon)/oom_score{_adj,}
-900
7441500919753
# grep RSS /proc/$(pidof dbus-daemon)/status
VmRSS:	    1660 kB



	Dave
