Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934193Ab2FHUPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 16:15:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55995 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759440Ab2FHUPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 16:15:53 -0400
Date: Fri, 8 Jun 2012 13:15:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: oomkillers gone wild.
In-Reply-To: <20120605174454.GA23867@redhat.com>
Message-ID: <alpine.DEB.2.00.1206081313000.19054@chino.kir.corp.google.com>
References: <20120604152710.GA1710@redhat.com> <alpine.DEB.2.00.1206041629500.7769@chino.kir.corp.google.com> <20120605174454.GA23867@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012, Dave Jones wrote:

> Still doesn't seem right..
> 
> eg..
> 
> [42309.542776] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
> ..
> [42309.553933] [  500]    81   500     5435        1   4     -13          -900 dbus-daemon
> ..
> [42309.597531] [ 9054]  1000  9054   528677    14540   3       0             0 trinity-child3
> ..
> 
> [42309.643057] Out of memory: Kill process 500 (dbus-daemon) score 511952 or sacrifice child
> [42309.643620] Killed process 500 (dbus-daemon) total-vm:21740kB, anon-rss:0kB, file-rss:4kB
> 
> and a slew of similar 'wrong process' death spiral kills follows..
> 

On a system not under oom conditions, i.e. before you start trinity, can 
you send the output of

	cat /proc/$(pidof dbus-daemon)/oom_score{_adj,}
	grep RSS /proc/$(pidof dbus-daemon)/status
