Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762Ab0HLSV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 14:21:58 -0400
Received: from thunk.org ([69.25.196.29]:58716 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760752Ab0HLSV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 14:21:56 -0400
Date: Thu, 12 Aug 2010 14:21:28 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, peterz@infradead.org,
        tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100812182128.GC2763@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
	Brian Swetland <swetland@google.com>,
	linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
	florian@mickler.org, rjw@sisk.pl, peterz@infradead.org,
	tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
	James.Bottomley@suse.de, arjan@infradead.org, swmike@swm.pp.se,
	galibert@pobox.com, dipankar@in.ibm.com
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
 <Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
 <AANLkTinMwt27wuDUh32F36wpoC54Syzp1_nK9UCxYmEK@mail.gmail.com>
 <20100812125248.GA2763@thunk.org>
 <AANLkTin4=qpDWEKLwes_af6mSCW+ED7v-fWzD34JywU1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin4=qpDWEKLwes_af6mSCW+ED7v-fWzD34JywU1@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 07:46:03PM +0300, Felipe Contreras wrote:

> All the Android community had to do is push the drivers *without*
> suspend blockers, then the Android kernel wouldn't be so different and
> thus wouldn't be considered a fork. AFAIU the kernel side wakelocks
> are already in the kernel, so there's no excuse not to merge the
> drivers.

What's there is not good enough, because it's missing the statistics
and reporting so that badly behaved kernel and userspace drivers that
take wakelocks can be found.

I have a similar problem with the whole pm_qos subsystem, as I've said
earlier.  If some badly behaved application claims to want 0us
wireless latency, and keeps the radio on all the time, there is no way
for me to find out which is the badly behaved application --- even
though I'm the owner of the laptop, and at the end of the day *I*
should be able to say, no, battery lifetime is more important than
what the application might think is its "minimum wireless latency".
Not only can I not override the application, I can't even find out
which application is at fault!   ***FAIL***

In some ways, this is exactly the same problem as the "which badly
Maemo application is causing my causing my N770 to have its battery
laptop drop in half?".

     	 	     	   	    	- Ted
