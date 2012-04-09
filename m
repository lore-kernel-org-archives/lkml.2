Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666Ab2DIS10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:27:26 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34704 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab2DIS1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:27:24 -0400
Date: Mon, 9 Apr 2012 11:27:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 25/69] TTY: con3215, remove tasklet for tty_wakeup
Message-ID: <20120409182720.GA12044@kroah.com>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
 <1333367693-3244-26-git-send-email-jslaby@suse.cz>
 <20120403054241.GA2700@osiris.boeblingen.de.ibm.com>
 <4F7AADD7.5070802@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7AADD7.5070802@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 09:59:19AM +0200, Jiri Slaby wrote:
> On 04/03/2012 07:42 AM, Heiko Carstens wrote:
> > On Mon, Apr 02, 2012 at 01:54:09PM +0200, Jiri Slaby wrote:
> >> tty_wakeup is safe to be called from all contexts. No need to schedule
> >> a tasklet for that. Let us call it directly like in other drivers.
> >>
> >> And delete the tasklet completely.
> > 
> > Your patch actually reverts Martin's recent commit 656d912537
> > "[S390] 3215 deadlock with tty_wakeup".
> > I'm quite sure the reason for the deadlock still exists.
> > Unfortunately the commit doesn't contain the call chain that
> > led to fix.
> 
> Ok, I would really appreciate the trace.
> 
> If this is really an issue, we should provide a helper in the TTY layer
> like tty_schedule_wakeup.

Jiri, should I not apply this patch?

thanks,

greg k-h
