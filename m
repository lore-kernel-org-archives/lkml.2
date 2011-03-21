Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1CUW6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 18:58:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51513 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506Ab1CUW6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:58:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Suspend/resume regression in Toshiba A11 since 2.6.34-rc4
Date: Mon, 21 Mar 2011 23:58:43 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
References: <20110318220034.GA10162@herton-IdeaPad-Y430> <201103192152.52645.rjw@sisk.pl> <20110321115240.GA1655@herton-IdeaPad-Y430>
In-Reply-To: <20110321115240.GA1655@herton-IdeaPad-Y430>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103212358.43614.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 21, 2011, Herton Ronaldo Krzesinski wrote:
> On Sat, Mar 19, 2011 at 09:52:52PM +0100, Rafael J. Wysocki wrote:
> > On Saturday, March 19, 2011, Herton Ronaldo Krzesinski wrote:
> > > On Fri, Mar 18, 2011 at 11:38:52PM +0100, Rafael J. Wysocki wrote:
> > > > On Friday, March 18, 2011, Herton Ronaldo Krzesinski wrote:
> > > > > This regression is old, but discovered recently. Since 2.6.34-rc4,
> > > > > a Toshiba Tecra A11 machine resumes without video for the first time.
> > > > > Here is the strange thing reported, on the first suspend/resume, when
> > > > > the machine wakes up the video is blank, but the machine is up (just the
> > > > > screen is black). If you suspend again, on second resume the video comes
> > > > > back normally.
> > > > > 
> > > > > Helping the reporter bisecting the problem, we narrowed down the bug to
> > > > > this commit:
> > > > > 
> > > > > commit ac7729da880e742613129ee6dea0045328670d2d
> > > > > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > Date:   Mon Apr 5 01:43:51 2010 +0200
> > > > > 
> > > > >     ACPI / PM: Move ACPI video resume to a PM notifier
> > > > > 
> > > > > And reverting this commit on 2.6.38 still made the problem go away.
> > > > > Looking at the commit above I don't saw any problem, and perhaps we have
> > > > > some bad bios here which by moving the resume of acpi video later
> > > > > triggers this bug. Also strange that on second suspend/resume everything
> > > > > is normal... (the regression here is just the video is blank on first
> > > > > resume).
> > > > > 
> > > > > I asked the reporter to try to increase brightness logged in remotely
> > > > > when the video is blank after first resume, but this didn't have any
> > > > > effect.
> > > > > 
> > > > > This was reported in https://bugs.launchpad.net/bugs/719620 (if reading
> > > > > I recommend to skip to comment #58 and later), I can't think of any
> > > > > solution besides trying to move acpi video resume perhaps back and
> > > > > depend on video device being resume first. I asked for more debugging
> > > > > information but got nothing unfortunately which could diagnose better
> > > > > this...
> > > > 
> > > > What graphics driver is used?
> > > 
> > > i915
> > 
> > In the KMS mode I guess?
> 
> Yes, in KMS mode.

OK, I have no idea how to fix this.

Matthew, can you please have a look here?

Rafael
