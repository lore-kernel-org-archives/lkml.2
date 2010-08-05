Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab0HEOnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:43:25 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43234 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933314Ab0HEOkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:40:19 -0400
Date: Thu, 5 Aug 2010 07:40:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: david@lang.hm
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, tytso@mit.edu, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take two
Message-ID: <20100805144012.GE2447@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100804195704.GA23681@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008050616340.25170@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008050616340.25170@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 06:18:42AM -0700, david@lang.hm wrote:
> On Wed, 4 Aug 2010, Paul E. McKenney wrote:
> 
> >Continuing to rush in where angels fear to tread...
> 
> here here :-)
> 
> >o	"PM-driving application" are applications that are permitted
> >	to acquire suspend blockers on Android.  Verion 8 of the
> >	suspend-blocker patch seems to use group permissions to determine
> >	which applications are classified as power aware.  More generally,
> >	PM-driving applications seem to be those that have permission
> >	to exert some control over the system's sleep state.
> >
> >	Note that an application might be power-oblivious on one Android
> >	device and PM-driving on another, depending on whether the user
> >	allows that application to acquire suspend blockers.  The
> >	classification might even change over time.  For example, a
> >	user might give an application PM-driving status initially,
> >	but change his or her mind after some experience with that
> >	application.
> 
> One thing that I think it's important to document here is
> theinformation that Brian provided in response to your question
> about how many (or actually how few) applications fall into this
> catefory

Agreed!!!  I have added this, and it will appear in the next version.

							Thanx, Paul

> David Lang
> 
> Quote:
> 
> >I should have asked this earlier...  What exactly are the apps'
> >compatibility constraints?  Source-level APIs?  Byte-code class-library
> >invocations?  C/C++ dynamic linking?  C/C++ static linking (in other
> >words, syscall)?
> 
> For Java/Dalvik apps, the wakelock API is pertty high level -- it
> talks to a service via RPC (Binder) that actually interacts with the
> kernel.  Changing the basic kernel<->userspace interface (within
> reason) is not unthinkable.  For example, Arve's suspend_blocker patch
> provides a device interface rather than the proc interface the older
> wakelock patches use.  We'd have to make some userspace changes to
> support that but they're pretty low level and minor.
> 
> In the current model, only a few processes need to specifically
> interact with the kernel (the power management service in the
> system_server, possibly the media_server and the radio interface
> glue).  A model where every process needs to have a bunch of
> instrumentation is not very desirable from our point of view.  We
> definitely do need reasonable statistics in order to enable debugging
> and to enable reporting to endusers (through the Battery Usage UI)
> what's keeping the device awake.
> 
> Brian
> 
