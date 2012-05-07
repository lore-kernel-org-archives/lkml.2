Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab2EGS65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:58:57 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:64567 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499Ab2EGS64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 14:58:56 -0400
Date: Mon, 7 May 2012 11:58:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Brian Swetland <swetland@google.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: android: logger: Allocate logs dynamically at
 boot
Message-ID: <20120507185852.GA1838@kroah.com>
References: <4FA4673C.7010209@am.sony.com>
 <20120504233707.GA24213@kroah.com>
 <4FA8195E.2010706@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA8195E.2010706@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 11:50:06AM -0700, Tim Bird wrote:
> On 05/04/2012 04:37 PM, Greg KH wrote:
> > On Fri, May 04, 2012 at 04:33:16PM -0700, Tim Bird wrote:
> >> +#define MAX_LOGS	5
> >> +struct logger_log *logs_array[MAX_LOGS];
> > 
> > You are going to make this a list and not a static array in the
> > future, right?
> 
> Would that be better?  The for-loop is IMHO simpler than a
> list walk for finding matches.  I anticipate that the size of
> this array should never (famous last words) be bigger than about
> 20 entries, even in the dynamic-allocation-per-application
> case.  And that's a ways off in implementation.
> 
> I'll be happy to switch to a linked list once it looks like we're
> going to have more than 5 entries.  Or I can switch to a linked
> list now if you think it's better form to code for the longer-term
> anticipated features.
> 
> Not a big deal to me either way.

For now, it's fine, just in the future I imagine, if you are going to
continue down the patch of this type of api and interface, you will want
to make it dynamic.

> >> -static int __init init_log(struct logger_log *log)
> >> +static int __init add_log(struct logger_log *log)
> >>  {
> >> -	int ret;
> >> +	int i;
> >>
> >> +	for (i = 0; i < MAX_LOGS; i++) {
> >> +		if (logs_array[i] == 0) {
> >> +			logs_array[i] = log;
> >> +			return 0;
> >> +		}
> >> +	}
> >> +	return -1;
> >> +}
> > 
> > I see you didn't run your patch through sparse :(
> 
> Indeed - shame on me. :-(
> 
> > Care to fix up the sparse warnings and resend?
> OK - this patch has 2 sparse issues, and there were
> 2 already in the code.  Do you want me to send the
> other 2 sparse fixes as an independent patch, or could
> I cheat and throw them in this one?

Fix your patch first and resend it.  You can send the 'fix up sparse
warnings' patch after it if you want to.

I don't want to add new patches that add new checkpatch and sparse
problems, the goal of having the code in the staging tree is that it
gets better over time, not worse :)

thanks,

greg k-h
