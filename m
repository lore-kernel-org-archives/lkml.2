Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2LYU1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 15:27:49 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:44374 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab2LYU1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 15:27:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/25] PM / Domains: don't use [delayed_]work_pending()
Date: Tue, 25 Dec 2012 21:33:07 +0100
Message-ID: <43765611.nGGJ409TUC@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <20121225170328.GH10220@mtj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org> <21556832.hKrqJSonFg@vostro.rjw.lan> <20121225170328.GH10220@mtj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 25, 2012 09:03:28 AM Tejun Heo wrote:
> Hello, Rafael.
> 
> On Sat, Dec 22, 2012 at 12:57:20PM +0100, Rafael J. Wysocki wrote:
> > On Friday, December 21, 2012 05:57:06 PM Tejun Heo wrote:
> > > There's no need to test whether a (delayed) work item in pending
> > > before queueing, flushing or cancelling it.  Most uses are unnecessary
> > > and quite a few of them are buggy.
> > 
> > Is the particular one you're removing from domain.c buggy?
> 
> It's a bit difficult to tell without understanding the code base but
> from quick glancing it looks like it could be.  The queueing and
> actual excution don't grab the same lock, so there doesn't seem to be
> anything work_pending() returning %true for a work item which already
> started executing.  Even if the bug is there, it's likely to be very
> difficult to trigger tho, so I wouldn't consider it an urgent fix.

OK, so I'd generally prefer changelogs like this:

"There's no need to test whether a (delayed) work item is pending
before queueing, flushing or cancelling it, so remove work_pending()
tests used in those cases."

If that's fine with you, I'll queue up [16/25] and [11/25] for v3.9
with the above as the changelog.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
