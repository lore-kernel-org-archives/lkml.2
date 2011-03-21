Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1CULwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 07:52:50 -0400
Received: from adelie.canonical.com ([91.189.90.139]:33308 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1CULws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 07:52:48 -0400
Date: Mon, 21 Mar 2011 08:52:41 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suspend/resume regression in Toshiba A11 since 2.6.34-rc4
Message-ID: <20110321115240.GA1655@herton-IdeaPad-Y430>
References: <20110318220034.GA10162@herton-IdeaPad-Y430>
 <201103182338.52808.rjw@sisk.pl>
 <20110319153533.GA2457@herton-P35C-DS3R>
 <201103192152.52645.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103192152.52645.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 19, 2011 at 09:52:52PM +0100, Rafael J. Wysocki wrote:
> On Saturday, March 19, 2011, Herton Ronaldo Krzesinski wrote:
> > On Fri, Mar 18, 2011 at 11:38:52PM +0100, Rafael J. Wysocki wrote:
> > > On Friday, March 18, 2011, Herton Ronaldo Krzesinski wrote:
> > > > This regression is old, but discovered recently. Since 2.6.34-rc4,
> > > > a Toshiba Tecra A11 machine resumes without video for the first time.
> > > > Here is the strange thing reported, on the first suspend/resume, when
> > > > the machine wakes up the video is blank, but the machine is up (just the
> > > > screen is black). If you suspend again, on second resume the video comes
> > > > back normally.
> > > > 
> > > > Helping the reporter bisecting the problem, we narrowed down the bug to
> > > > this commit:
> > > > 
> > > > commit ac7729da880e742613129ee6dea0045328670d2d
> > > > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > > > Date:   Mon Apr 5 01:43:51 2010 +0200
> > > > 
> > > >     ACPI / PM: Move ACPI video resume to a PM notifier
> > > > 
> > > > And reverting this commit on 2.6.38 still made the problem go away.
> > > > Looking at the commit above I don't saw any problem, and perhaps we have
> > > > some bad bios here which by moving the resume of acpi video later
> > > > triggers this bug. Also strange that on second suspend/resume everything
> > > > is normal... (the regression here is just the video is blank on first
> > > > resume).
> > > > 
> > > > I asked the reporter to try to increase brightness logged in remotely
> > > > when the video is blank after first resume, but this didn't have any
> > > > effect.
> > > > 
> > > > This was reported in https://bugs.launchpad.net/bugs/719620 (if reading
> > > > I recommend to skip to comment #58 and later), I can't think of any
> > > > solution besides trying to move acpi video resume perhaps back and
> > > > depend on video device being resume first. I asked for more debugging
> > > > information but got nothing unfortunately which could diagnose better
> > > > this...
> > > 
> > > What graphics driver is used?
> > 
> > i915
> 
> In the KMS mode I guess?

Yes, in KMS mode.

> 
> Rafael
> 

-- 
[]'s
Herton
