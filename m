Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab2KNP6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:58:53 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:4365 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab2KNP6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:58:51 -0500
Message-ID: <1352908726.2883.0.camel@lorien2>
Subject: Re: [PATCH 03/11] intel-iommu: Fix AB-BA lockdep report
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, stable <stable@vger.kernel.org>,
        roland@purestorage.com, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        David Woodhouse <David.Woodhouse@intel.com>, shuahkhan@gmail.com
Date: Wed, 14 Nov 2012 08:58:46 -0700
In-Reply-To: <20121114033444.GA29560@kroah.com>
References: <20111204185444.411298317@goodmis.org>
	 <20111204190008.804987080@goodmis.org> <1352859923.7889.2.camel@lorien2>
	 <1352862293.18025.52.camel@gandalf.local.home>
	 <20121114033444.GA29560@kroah.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-13 at 19:34 -0800, Greg Kroah-Hartman wrote:
> On Tue, Nov 13, 2012 at 10:04:53PM -0500, Steven Rostedt wrote:
> > On Tue, 2012-11-13 at 19:25 -0700, Shuah Khan wrote:
> > > On Sun, 2011-12-04 at 13:54 -0500, Steven Rostedt wrote:
> > > > From: Roland Dreier <roland@purestorage.com>
> > > > 
> > > > When unbinding a device so that I could pass it through to a KVM VM, I
> > > > got the lockdep report below.  It looks like a legitimate lock
> > > > ordering problem:
> > > 
> > > Did this patch not make it into stable releases other than 3.1. I
> > > couldn't find it in any other stable tress prior to 3.1.
> > 
> > Ah, this was done in the early stable-rt releases. Where we took
> > mainline fixes as long as they were in tglx's tree. But today the
> > stable-rt tree waits for mainline fixes to come in via the stable tree
> > so we don't do something like this. That is, miss getting a fix into
> > stable.  Yeah, this should be added to 3.0. (looks to be already in 3.2
> > and 3.4).
> > 
> > 
> > Greg,
> > 
> > Can you add the following commit to the 3.0 stable tree. We've had this
> > in v3.0-rt for some time now. :-/
> > 
> > commit 3e7abe2556b583e87dabda3e0e6178a67b20d06f
> > Author: Roland Dreier <roland@purestorage.com>
> > Date:   Wed Jul 20 06:22:21 2011 -0700
> > 
> >     intel-iommu: Fix AB-BA lockdep report
> 
> I had to edit the path to the file, but it looks like it applies
> properly now, thanks.


Thanks,
-- Shuah


