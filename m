Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab2LQXaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 18:30:22 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36443 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab2LQXaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 18:30:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jan-Matthias Braun <jan_braun@gmx.net>
Subject: Re: [Resend][PATCH] PM: Move disabling/enabling runtime PM to late suspend/early resume
Date: Tue, 18 Dec 2012 00:35:31 +0100
Message-ID: <1689510.lSH9oXFSB8@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAPDyKFpXAokEr-ktU9=R+SWnfJvhRNhYPbmz-pw8-YpJiuNSSA@mail.gmail.com>
References: <3558004.3QJ46yYCyI@vostro.rjw.lan> <Pine.LNX.4.44L0.1212161028330.13850-100000@netrider.rowland.org> <CAPDyKFpXAokEr-ktU9=R+SWnfJvhRNhYPbmz-pw8-YpJiuNSSA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 17, 2012 10:18:14 PM Ulf Hansson wrote:
> On 16 December 2012 16:29, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Sun, 16 Dec 2012, Rafael J. Wysocki wrote:
> >
> >> On Saturday, December 15, 2012 10:16:29 PM Jiri Kosina wrote:
> >> > On Sat, 15 Dec 2012, Rafael J. Wysocki wrote:
> >> >
> >> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> > >
> >> > > Currently, the PM core disables runtime PM for all devices right
> >> > > after executing subsystem/driver .suspend() callbacks for them
> >> > > and re-enables it right before executing subsystem/driver .resume()
> >> > > callbacks for them.  This may lead to problems when there are
> >> > > two devices such that the .suspend() callback executed for one of
> >> > > them depends on runtime PM working for the other.  In that case,
> >> > > if runtime PM has already been disabled for the second device,
> >> > > the first one's .suspend() won't work correctly (and analogously
> >> > > for resume).
> >> > >
> >> > > To make those issues go away, make the PM core disable runtime PM
> >> > > for devices right before executing subsystem/driver .suspend_late()
> >> > > callbacks for them and enable runtime PM for them right after
> >> > > executing subsystem/driver .resume_early() callbacks for them.  This
> >> > > way the potential conflitcs between .suspend_late()/.resume_early()
> >> > > and their runtime PM counterparts are still prevented from happening,
> >> > > but the subtle ordering issues related to disabling/enabling runtime
> >> > > PM for devices during system suspend/resume are much easier to avoid.
> >> > >
> >> > > Reported-and-tested-by: Jan-Matthias Braun <jan_braun@gmx.net>
> >> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> >
> >> > Hi Rafael,
> >> >
> >> > just curious what is the reason for resend? Do you want to gather more
> >> > Acks before pushing this upstream?
> >>
> >> Well, I thought that some people might actually look at it when they found it
> >> again in their mailboxes. :-)
> >
> > I did look at it the first time it appeared.  It seemed to be okay, but
> > I haven't tried any testing.
> >
> > Alan Stern
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> I believe this should work fine for ux500 platforms, so:
> 
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
