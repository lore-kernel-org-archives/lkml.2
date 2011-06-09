Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab1FIOwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:52:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58716 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1FIOwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:52:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=av7Ht6Y1V+a7zdkF0BDcD3wqqdsFO3W86SxpBcW8QnTSBFetBy8uYuJ2v9aiBYWfHr
         v6+u4rGaxSC5CKu+c12Q==
Date: Thu, 9 Jun 2011 07:51:59 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/4] watchdog: fix rounding issues in
 get_sample_period()
Message-ID: <20110609145159.GG17986@google.com>
References: <1305588901-8141-1-git-send-email-msb@chromium.org>
 <20110518135302.GM29881@redhat.com>
 <20110519162631.GJ11023@google.com>
 <20110609114745.GQ8162@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609114745.GQ8162@redhat.com>
X-Operating-System: Linux/2.6.32-gg426-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus (dzickus@redhat.com) wrote:
> On Thu, May 19, 2011 at 09:26:31AM -0700, Mandeep Singh Baines wrote:
> > Don Zickus (dzickus@redhat.com) wrote:
> > > On Mon, May 16, 2011 at 04:34:58PM -0700, Mandeep Singh Baines wrote:
> > > > In get_sample_period(), softlockup_thresh is integer divided by 5 before
> > > > the multiplication by NSEC_PER_SEC. This results in softlockup_thresh
> > > > being rounded down to the nearest integer multiple of 5.
> > > > 
> > > > For example, a softlockup_thresh of 4 rounds down to 0.
> > > 
> > > Mandeep,
> > > 
> > > Thanks for the patches.  Unfortunately, I am taking some time off so I'll
> > > shephard these patches when I get back.  For the most part they look fine,
> > > aside from Ingo's comments.
> > > 
> > 
> > No problem. Enjoy your time off:)
> > 
> > Ingo, since Don is out, would you mind acking the patches (assuming you're
> > happy). It simplifies pushing these patches into our local ChromiumOS tree
> > if I have an upstream ack.
> 
> Hi Mandeep,
> 
> It looks like Ingo took most of your patches.  Is there any outstanding
> ones that didn't make it that you see?
> 

Hi Don,

Thanks for following up. All the patches are now in.

I am working on a few new NMI issues so I'll be sending out a few patches
in a day or so. I've committed one critical fix to our 2.6.32 tree and am now
working on forward-porting it to tip/master:

http://git.chromium.org/gitweb/?p=chromiumos/third_party/kernel.git;a=commitdiff;h=2a825f5f38f24e655dd655253eaaa5a82460a43e;hp=09ecdd5b43b9df930efd51a3fe317c18907a6c2d

Regards,
Mandeep

> Cheers,
> Don
