Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab0KKMXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:23:47 -0500
Received: from kroah.org ([198.145.64.141]:53054 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab0KKMXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:23:46 -0500
Date: Thu, 11 Nov 2010 04:19:17 -0800
From: Greg KH <greg@kroah.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs, sysfs: Change sysfs_pathname function prototype.
Message-ID: <20101111121917.GA933@kroah.com>
References: <AANLkTikDXtLrfjYkQrkGi44qi0cpp-C+Lxr5j1UkFd2G@mail.gmail.com> <20101109224450.GB21992@kroah.com> <AANLkTimHOAdUieTzFvNNhaPxwvas2wBDfSL8aPu764HZ@mail.gmail.com> <20101110183940.GA15089@kroah.com> <AANLkTimTy0vngwuM=jWfeU7qgqznamPgAftX7=2LShL+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimTy0vngwuM=jWfeU7qgqznamPgAftX7=2LShL+@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 12:11:34PM +0600, Rakib Mullick wrote:
> On Thu, Nov 11, 2010 at 12:39 AM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Nov 10, 2010 at 10:53:37AM +0600, Rakib Mullick wrote:
> >> On Wed, Nov 10, 2010 at 4:44 AM, Greg KH <greg@kroah.com> wrote:
> >> >
> >> > If it's really not used then why would marking it inline help out any?
> >> > Shouldn't we just delete the function instead?
> >> >
> >> As far as I can see, its been called recursively and also from
> >> sysfs_add_one. Am I missing anything?
> >
> > If so, then what is the compiler warning that is being generated that
> > you are trying to resolve?
> >
> 
> Yes - its really confusing. Actually, sysfs_pathname is called from
> WARN(). So - when #ifndef WARN is false, then we're having that
> problem and sysfs_pathname isn't used that time. So, the proposed
> patch isn't the correct fix. Maybe, splitting up the WARN message and
> calling sysfs_pathname is the correct one. Am I right?

perhaps, yes, that might be correct, but as almost no one builds with
WARN not enabled, is this a real issue?

thanks,

greg k-h
