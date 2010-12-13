Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab0LMDq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 22:46:26 -0500
Received: from netrider.rowland.org ([192.131.102.5]:37718 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751547Ab0LMDqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 22:46:24 -0500
Date: Sun, 12 Dec 2010 22:46:24 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC][PATCH 1/4] PM: Use a different list of devices
 for each stage of device suspend
In-Reply-To: <Pine.LNX.4.44L0.1012122237360.4379-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1012122245040.4379-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Dec 2010, Alan Stern wrote:

> On Mon, 13 Dec 2010, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Instead of keeping all devices in the same list during system suspend
> > and resume, regardless of what suspend-resume callbacks have been
> > executed for them already, use separate lists of devices that have
> > had their ->prepare(), ->suspend() and ->suspend_noirq() callbacks
> > executed.  This will allow us to simplify the core device suspend and
> > resume routines.
> 
> Okay in principle.  But there's one mistake...
> 
> > @@ -699,8 +693,8 @@ static void dpm_complete(pm_message_t st
> >  	INIT_LIST_HEAD(&list);
> >  	mutex_lock(&dpm_list_mtx);
> >  	transition_started = false;
> > -	while (!list_empty(&dpm_list)) {
> > -		struct device *dev = to_device(dpm_list.prev);
> > +	while (!list_empty(&dpm_prepared_list)) {
> > +		struct device *dev = to_device(dpm_prepared_list.prev);
> >  
> >  		get_device(dev);
> >  		if (dev->power.status > DPM_ON) {
> 
> The parts about getting rid of "list" and putting dev back onto
> dpm_list got left out.

Never mind.  I forgot that we need to keep using the intermediate list
in order to handle new devices being registered while the resumes are
taking place.

Alan Stern

