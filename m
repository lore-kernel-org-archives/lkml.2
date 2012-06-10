Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab2FJCVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 22:21:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59495 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab2FJCVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 22:21:03 -0400
Date: Sat, 9 Jun 2012 19:21:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: oomkillers gone wild.
In-Reply-To: <20120608210330.GA21010@redhat.com>
Message-ID: <alpine.DEB.2.00.1206091920140.7832@chino.kir.corp.google.com>
References: <20120604152710.GA1710@redhat.com> <alpine.DEB.2.00.1206041629500.7769@chino.kir.corp.google.com> <20120605174454.GA23867@redhat.com> <alpine.DEB.2.00.1206081313000.19054@chino.kir.corp.google.com> <20120608210330.GA21010@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2012, Dave Jones wrote:

>  > On a system not under oom conditions, i.e. before you start trinity, can 
>  > you send the output of
>  > 
>  > 	cat /proc/$(pidof dbus-daemon)/oom_score{_adj,}
>  > 	grep RSS /proc/$(pidof dbus-daemon)/status
> 
> # cat /proc/$(pidof dbus-daemon)/oom_score{_adj,}
> -900
> 7441500919753
> # grep RSS /proc/$(pidof dbus-daemon)/status
> VmRSS:	    1660 kB

I'm suspecting you don't have my patch that changes the type of the 
automatic variable in oom_badness() to signed.  Could you retry this with 
that patch or pull 3.5-rc2 which already includes it?
