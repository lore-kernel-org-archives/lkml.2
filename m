Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339Ab0HENV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 09:21:28 -0400
Received: from mail.lang.hm ([64.81.33.126]:44790 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758448Ab0HENVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 09:21:23 -0400
Date: Thu, 5 Aug 2010 06:18:42 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, tytso@mit.edu, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take two
In-Reply-To: <20100804195704.GA23681@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1008050616340.25170@asgard.lang.hm>
References: <20100731175841.GA9367@linux.vnet.ibm.com> <20100804195704.GA23681@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Paul E. McKenney wrote:

> Continuing to rush in where angels fear to tread...

here here :-)

> o	"PM-driving application" are applications that are permitted
> 	to acquire suspend blockers on Android.  Verion 8 of the
> 	suspend-blocker patch seems to use group permissions to determine
> 	which applications are classified as power aware.  More generally,
> 	PM-driving applications seem to be those that have permission
> 	to exert some control over the system's sleep state.
>
> 	Note that an application might be power-oblivious on one Android
> 	device and PM-driving on another, depending on whether the user
> 	allows that application to acquire suspend blockers.  The
> 	classification might even change over time.  For example, a
> 	user might give an application PM-driving status initially,
> 	but change his or her mind after some experience with that
> 	application.

One thing that I think it's important to document here is theinformation 
that Brian provided in response to your question about how many (or 
actually how few) applications fall into this catefory

David Lang

Quote:

> I should have asked this earlier...  What exactly are the apps'
> compatibility constraints?  Source-level APIs?  Byte-code class-library
> invocations?  C/C++ dynamic linking?  C/C++ static linking (in other
> words, syscall)?

For Java/Dalvik apps, the wakelock API is pertty high level -- it
talks to a service via RPC (Binder) that actually interacts with the
kernel.  Changing the basic kernel<->userspace interface (within
reason) is not unthinkable.  For example, Arve's suspend_blocker patch
provides a device interface rather than the proc interface the older
wakelock patches use.  We'd have to make some userspace changes to
support that but they're pretty low level and minor.

In the current model, only a few processes need to specifically
interact with the kernel (the power management service in the
system_server, possibly the media_server and the radio interface
glue).  A model where every process needs to have a bunch of
instrumentation is not very desirable from our point of view.  We
definitely do need reasonable statistics in order to enable debugging
and to enable reporting to endusers (through the Battery Usage UI)
what's keeping the device awake.

Brian

