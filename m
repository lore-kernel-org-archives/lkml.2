Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab0HDSc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:32:57 -0400
Received: from mail.lang.hm ([64.81.33.126]:58577 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab0HDSc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:32:56 -0400
Date: Wed, 4 Aug 2010 11:30:44 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100804163509.GA31523@srcf.ucam.org>
Message-ID: <alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm>
References: <20100731175841.GA9367@linux.vnet.ibm.com> <20100731215214.2543c07e@infradead.org> <20100801054816.GI2470@linux.vnet.ibm.com> <20100731230101.7cc1d8c7@infradead.org> <20100801191228.GL2470@linux.vnet.ibm.com> <20100801154708.19817b75@infradead.org>
 <20100802011006.GS2470@linux.vnet.ibm.com> <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com> <20100803183447.0275c134@infradead.org> <20100804163216.GB24163@linux.vnet.ibm.com> <20100804163509.GA31523@srcf.ucam.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Matthew Garrett wrote:

> On Wed, Aug 04, 2010 at 09:32:16AM -0700, Paul E. McKenney wrote:
>
>> If this doesn't work for the Android folks for whatever reason, another
>> approach would be to do the freeze in user code, which could track
>> whether any user-level resources (pthread mutexes, SysV semas, whatever)
>> where held, and do the freeze on a thread-by-thread basis within each
>> "victim" application as the threads reach safe points.
>
> The main problem I see with the cgroups solution is that it doesn't seem
> to do anything to handle avoiding loss of wakeup events.

there are two cgroup solutions in discussion at this point.

weeks ago there was the suggestion to put non-privilaged tasks in a cgroup 
so that they could be frozen as a group. I thought the problem there was 
that there can be user-space dpendancies that would prevent privilaged 
tasks from working.

a couple days ago I made the suggestion to put non-privilaged tasks in a 
cgroup so that the idle/suspend decision code could ignore acitivity 
caused by this cgroup.

in the second version wakeup events would be 'activity' that would be 
counted and therefor the system would not be idle. As for the race with 
suspending and new things happening, wouldn't that be handled the same way 
that it is in a normal linux box?

David Lang
