Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab1CSUwt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 16:52:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46852 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757469Ab1CSUwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 16:52:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: Suspend/resume regression in Toshiba A11 since 2.6.34-rc4
Date: Sat, 19 Mar 2011 21:52:52 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20110318220034.GA10162@herton-IdeaPad-Y430> <201103182338.52808.rjw@sisk.pl> <20110319153533.GA2457@herton-P35C-DS3R>
In-Reply-To: <20110319153533.GA2457@herton-P35C-DS3R>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103192152.52645.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 19, 2011, Herton Ronaldo Krzesinski wrote:
> On Fri, Mar 18, 2011 at 11:38:52PM +0100, Rafael J. Wysocki wrote:
> > On Friday, March 18, 2011, Herton Ronaldo Krzesinski wrote:
> > > This regression is old, but discovered recently. Since 2.6.34-rc4,
> > > a Toshiba Tecra A11 machine resumes without video for the first time.
> > > Here is the strange thing reported, on the first suspend/resume, when
> > > the machine wakes up the video is blank, but the machine is up (just the
> > > screen is black). If you suspend again, on second resume the video comes
> > > back normally.
> > > 
> > > Helping the reporter bisecting the problem, we narrowed down the bug to
> > > this commit:
> > > 
> > > commit ac7729da880e742613129ee6dea0045328670d2d
> > > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > > Date:   Mon Apr 5 01:43:51 2010 +0200
> > > 
> > >     ACPI / PM: Move ACPI video resume to a PM notifier
> > > 
> > > And reverting this commit on 2.6.38 still made the problem go away.
> > > Looking at the commit above I don't saw any problem, and perhaps we have
> > > some bad bios here which by moving the resume of acpi video later
> > > triggers this bug. Also strange that on second suspend/resume everything
> > > is normal... (the regression here is just the video is blank on first
> > > resume).
> > > 
> > > I asked the reporter to try to increase brightness logged in remotely
> > > when the video is blank after first resume, but this didn't have any
> > > effect.
> > > 
> > > This was reported in https://bugs.launchpad.net/bugs/719620 (if reading
> > > I recommend to skip to comment #58 and later), I can't think of any
> > > solution besides trying to move acpi video resume perhaps back and
> > > depend on video device being resume first. I asked for more debugging
> > > information but got nothing unfortunately which could diagnose better
> > > this...
> > 
> > What graphics driver is used?
> 
> i915

In the KMS mode I guess?

Rafael
