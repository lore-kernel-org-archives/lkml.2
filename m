Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406Ab2DKXBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:01:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62178 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761375Ab2DKXBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:01:10 -0400
Date: Wed, 11 Apr 2012 16:01:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Regression + patch] i915 / PM: System resume broken on 945GM
Message-ID: <20120411230106.GA4694@kroah.com>
References: <201204120012.46826.rjw@sisk.pl>
 <20120411222002.GA27568@kroah.com>
 <201204120056.49066.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204120056.49066.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 12:56:48AM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> On Thursday, April 12, 2012, Greg Kroah-Hartman wrote:
> > On Thu, Apr 12, 2012 at 12:12:46AM +0200, Rafael J. Wysocki wrote:
> > > Hi Chris,
> > > 
> > > Unfortunately, your commit
> > > 
> > > commit 7dd4906586274f3945f2aeaaa5a33b451c3b4bba
> > > Author: Chris Wilson <chris@chris-wilson.co.uk>
> > > Date:   Wed Mar 21 10:48:18 2012 +0000
> > > 
> > >     drm/i915: Mark untiled BLT commands as fenced on gen2/3
> > > 
> > > breaks system resume on my Toshiba Portege R500 (945GM) which hangs hard
> > > during or right after returning to X.
> > 
> > Luckily this patch didn't apply properly to the 3.3-stable tree :)
> 
> Your box hanged during resume from suspend with it IIRC, though, or was that
> a different issue?

Different issue, that was fixed by
dba69d1092e291e257fb5673a3ad0e4c87878ebc (x86, kvm: Call
restore_sched_clock_state() only after %gs is initialized), which went
into Linus's tree right after 3.4-rc1 was out.  All is good in 3.4-rc2
for me, thankfully.

thanks,

greg k-h
