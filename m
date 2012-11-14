Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab2KNDeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 22:34:10 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39143 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab2KNDeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 22:34:08 -0500
Date: Tue, 13 Nov 2012 19:34:44 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: shuah.khan@hp.com, stable <stable@vger.kernel.org>, roland@purestorage.com,
        linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        David Woodhouse <David.Woodhouse@intel.com>, shuahkhan@gmail.com
Subject: Re: [PATCH 03/11] intel-iommu: Fix AB-BA lockdep report
Message-ID: <20121114033444.GA29560@kroah.com>
References: <20111204185444.411298317@goodmis.org>
 <20111204190008.804987080@goodmis.org>
 <1352859923.7889.2.camel@lorien2>
 <1352862293.18025.52.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352862293.18025.52.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 10:04:53PM -0500, Steven Rostedt wrote:
> On Tue, 2012-11-13 at 19:25 -0700, Shuah Khan wrote:
> > On Sun, 2011-12-04 at 13:54 -0500, Steven Rostedt wrote:
> > > From: Roland Dreier <roland@purestorage.com>
> > > 
> > > When unbinding a device so that I could pass it through to a KVM VM, I
> > > got the lockdep report below.  It looks like a legitimate lock
> > > ordering problem:
> > 
> > Did this patch not make it into stable releases other than 3.1. I
> > couldn't find it in any other stable tress prior to 3.1.
> 
> Ah, this was done in the early stable-rt releases. Where we took
> mainline fixes as long as they were in tglx's tree. But today the
> stable-rt tree waits for mainline fixes to come in via the stable tree
> so we don't do something like this. That is, miss getting a fix into
> stable.  Yeah, this should be added to 3.0. (looks to be already in 3.2
> and 3.4).
> 
> 
> Greg,
> 
> Can you add the following commit to the 3.0 stable tree. We've had this
> in v3.0-rt for some time now. :-/
> 
> commit 3e7abe2556b583e87dabda3e0e6178a67b20d06f
> Author: Roland Dreier <roland@purestorage.com>
> Date:   Wed Jul 20 06:22:21 2011 -0700
> 
>     intel-iommu: Fix AB-BA lockdep report

I had to edit the path to the file, but it looks like it applies
properly now, thanks.

greg k-h
