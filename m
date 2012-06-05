Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab2FERpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:45:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500Ab2FERpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:45:01 -0400
Date: Tue, 5 Jun 2012 13:44:54 -0400
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: oomkillers gone wild.
Message-ID: <20120605174454.GA23867@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
References: <20120604152710.GA1710@redhat.com>
 <alpine.DEB.2.00.1206041629500.7769@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206041629500.7769@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 04:30:57PM -0700, David Rientjes wrote:
 > On Mon, 4 Jun 2012, Dave Jones wrote:
 > 
 > > we picked this..
 > > 
 > > [21623.066911] [  588]     0   588    22206        1   2       0             0 dhclient
 > > 
 > > over say..
 > > 
 > > [21623.116597] [ 7092]  1000  7092  1051124    31660   3       0             0 trinity-child3
 > > 
 > > What went wrong here ?
 > > 
 > > And why does that score look so.. weird.
 > > 
 > 
 > It sounds like it's because pid 588 has uid=0 and the adjustment for root 
 > processes is causing an overflow.  I assume this fixes it?

Still doesn't seem right..

eg..

[42309.542776] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
..
[42309.553933] [  500]    81   500     5435        1   4     -13          -900 dbus-daemon
..
[42309.597531] [ 9054]  1000  9054   528677    14540   3       0             0 trinity-child3
..

[42309.643057] Out of memory: Kill process 500 (dbus-daemon) score 511952 or sacrifice child
[42309.643620] Killed process 500 (dbus-daemon) total-vm:21740kB, anon-rss:0kB, file-rss:4kB

and a slew of similar 'wrong process' death spiral kills follows..


	Dave

