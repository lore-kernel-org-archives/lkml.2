Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab2DITHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:07:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52343 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702Ab2DITHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:07:14 -0400
Date: Mon, 9 Apr 2012 12:07:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 25/69] TTY: con3215, remove tasklet for tty_wakeup
Message-ID: <20120409190710.GA14176@kroah.com>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
 <1333367693-3244-26-git-send-email-jslaby@suse.cz>
 <20120403054241.GA2700@osiris.boeblingen.de.ibm.com>
 <4F7AADD7.5070802@suse.cz>
 <20120409182720.GA12044@kroah.com>
 <4F832ABF.4060509@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F832ABF.4060509@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 08:30:23PM +0200, Jiri Slaby wrote:
> On 04/09/2012 08:27 PM, Greg KH wrote:
> > On Tue, Apr 03, 2012 at 09:59:19AM +0200, Jiri Slaby wrote:
> >> On 04/03/2012 07:42 AM, Heiko Carstens wrote:
> >>> On Mon, Apr 02, 2012 at 01:54:09PM +0200, Jiri Slaby wrote:
> >>>> tty_wakeup is safe to be called from all contexts. No need to schedule
> >>>> a tasklet for that. Let us call it directly like in other drivers.
> >>>>
> >>>> And delete the tasklet completely.
> >>>
> >>> Your patch actually reverts Martin's recent commit 656d912537
> >>> "[S390] 3215 deadlock with tty_wakeup".
> >>> I'm quite sure the reason for the deadlock still exists.
> >>> Unfortunately the commit doesn't contain the call chain that
> >>> led to fix.
> >>
> >> Ok, I would really appreciate the trace.
> >>
> >> If this is really an issue, we should provide a helper in the TTY layer
> >> like tty_schedule_wakeup.
> > 
> > Jiri, should I not apply this patch?
> 
> Yes, please skip it until this is sorted out. And also the other con3215
> patches if they don't apply cleanly now.

Ok, I've not applied patches 25, 26, and 27 in this series, but have
applied all others, thanks.

greg k-h
