Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab0LIEfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 23:35:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab0LIEfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 23:35:21 -0500
Date: Wed, 8 Dec 2010 23:34:35 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: perf hw  in kexeced kernel broken in tip
Message-ID: <20101209043435.GT21786@redhat.com>
References: <m162vdp3l4.fsf@fess.ebiederm.org>
 <20101202052321.GH18100@redhat.com>
 <1291275270.4023.20.camel@twins>
 <20101202161502.GL18100@redhat.com>
 <1291764620.2032.1293.camel@laptop>
 <20101208140103.GM21786@redhat.com>
 <1291818005.28378.38.camel@laptop>
 <1291820356.28378.83.camel@laptop>
 <20101208223746.GR21786@redhat.com>
 <m1oc8vetru.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1oc8vetru.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 03:20:37PM -0800, Eric W. Biederman wrote:
> Don Zickus <dzickus@redhat.com> writes:
> 
> > On Wed, Dec 08, 2010 at 03:59:16PM +0100, Peter Zijlstra wrote:
> >> On Wed, 2010-12-08 at 15:20 +0100, Peter Zijlstra wrote:
> >> 
> >> > > I wonder if you should reverse these checks.  If the bios has the perf
> >> > > counter enabled, there might be a high chance that it fails the first
> >> > > check and never gets to the actually bios checks.
> >> > 
> >> > Ah, good point. 
> >> 
> >> Something like so..
> >
> > This seems to work correctly on my Nehalem and broken bios machines during
> > boot and kexec.  As expected it fails during kdump.  My p4 box failed
> > during kexec for some reason.  But p4 has other issues.
> 
> Does the kdump kernel still boot?
> 
> It looks like it should I just want to double check.

Yeah, sorry for not being clear.  It definitely boots and does it thing.
perf init (and thus nmi watchdog) fail with 'BIOS broken' because the perf
counters were not shutdown prior to executing kdump.

Cheers,
Don
