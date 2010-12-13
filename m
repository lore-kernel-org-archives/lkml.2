Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab0LMTbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:31:20 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1317 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab0LMTbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:31:18 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Date: Mon, 13 Dec 2010 11:31:11 -0800
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Dave Hansen" <dave@sr71.net>
cc: "Greg KH" <gregkh@suse.de>, "John W. Linville" <linville@tuxdriver.com>,
        "Johannes Berg" <johannes@sipsolutions.net>,
        "Brett Rudley" <brudley@broadcom.com>,
        "Jason Cooper" <jason@lakedaemon.net>,
        "Mike Rapoport" <mike.rapoport@gmail.com>,
        "Andy Shevchenko" <andy.shevchenko@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Henry Ptasinski" <henryp@broadcom.com>, arend@broadcom.com,
        rvossen@broadcom.com
Subject: Re: brcm80211 hangs when disabling wireless
Message-ID: <20101213193111.GK2576@broadcom.com>
References: <1291930010.7960.30.camel@nimitz>
 <20101209214347.GA15172@suse.de> <1291931678.7960.32.camel@nimitz>
MIME-Version: 1.0
In-Reply-To: <1291931678.7960.32.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-WSS-ID: 6118AB2D3P040780762-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 01:54:38PM -0800, Dave Hansen wrote:
> On Thu, 2010-12-09 at 13:43 -0800, Greg KH wrote:
> > On Thu, Dec 09, 2010 at 01:26:50PM -0800, Dave Hansen wrote:
> > > I've been getting hard hangs when I toggle the wireless on a Lenovo
> > > S10-3.  It happens both with the physical switch and the Fn-F5 key
> > > combo.  It's quite repeatable.  The system is quite stable when I'm not
> > > trying to disable the wireless, though.
> > 
> > What kernel version is this?
> > 
> > Linus's latest tree has a known bug when the wireless is suspended and
> > then resumed.  Broadcom is working on it but no patch is forthcoming
> > yet.  Perhaps this is the same issue.
> 
> Yeah, it's 2.6.37-rc5 plus a pull from:
> 
> 	http://kernel.ubuntu.com/git?p=ikepanhc/ideapad-laptop.git;a=summary
> 
> That could easily be it.  Thanks, Greg.

Actually, I think it's the rfkill support (or lack thereof) that's causing you
trouble.  But we're looking at that as well.

The outstanding reported issues that I'm aware of are:
	- 43224 crashes
	- missing rfkill support
	- suspend/resume problems
	- 4313 infinite loop in some cases

In terms of process, should these all get filed in bugzilla.kernel.org (or
somewhere else), or just track them via email and our TODO list?

Thanks,
- Henry


