Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0ESH2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:28:36 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37361 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab0ESH2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:28:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h/+L2qMhasa7eSJtCZIYNFAkUL8dL8436xi2omXNBzJSJkpLg1s3F4sqLOv13qFPYO
         l8QVJOdfRTowGbwpOt9NHrIrQ/hQ+5iMmk3D75c/TX0aNIxl+duWPtkEgSwDwR0JzeDm
         YR7MBEeRGdUTzdXEAXzzGR4doz2eZ60aSIJK0=
Date: Wed, 19 May 2010 09:28:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: rostedt@goodmis.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: collecting static data related to tracing
Message-ID: <20100519072838.GD5704@nowhere>
References: <1274191742.31554.10.camel@jlt3.sipsolutions.net> <1274193698.26328.746.camel@gandalf.stny.rr.com> <1274193909.31554.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274193909.31554.12.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 04:45:09PM +0200, Johannes Berg wrote:
> On Tue, 2010-05-18 at 10:41 -0400, Steven Rostedt wrote:
> 
> > The latest version of trace-cmd has an "options" section. This allows
> > you to add options to the file.
> > 
> > We could make a plugin that also can be used by trace-cmd record, that
> > allows you to add options. The options are written such that if a
> > trace-cmd does not know how to deal with them, they will be ignored.
> > 
> > Hmm, but the options require a unique ID. Well we could register IDs
> > with plugins, or add a plugin id, which uses the name of the plugin as
> > an identifier too.
> > 
> > But this would allow you to add the details you want about the system
> > and then have the reader be able to print it out.
> > 
> > How's that sound?
> 
> Sounds good, although it does require that I tell people who want to
> record to also install the recording plugin, but that should be
> manageable :) I can just dig out the data from the regular debugfs once
> I add files containing it.
> 
> johannes


This is a place where events injection might be suitable perhaps.
Either kernel or user space event injection.

kernel space injection would be a simple trace event declared that
have a callback called when it gets enabled. This callback would
inject any events it wants.

userspace injection could be a bit different, the user can inject
its own format and events content toward a debugfs or whatever file.
This would be suitable if userspace have few things to inject,
otherwise we would need to think about something else perhaps.

