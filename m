Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab0LRPj6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:39:58 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38807 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab0LRPj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:39:57 -0500
Date: Sat, 18 Dec 2010 15:39:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/2 V3] applesmc: Use PnP rather than hardcoding
	resources and devices
Message-ID: <20101218153950.GA22649@srcf.ucam.org>
References: <20101217221618.GA13207@ericsson.com> <1292624661-32474-1-git-send-email-mjg@redhat.com> <20101218042320.GA14104@ericsson.com> <20101218093719.GA1493@polaris.bitmath.org> <20101218144329.GB21801@srcf.ucam.org> <20101218153012.GA1506@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101218153012.GA1506@polaris.bitmath.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 04:30:12PM +0100, Henrik Rydberg wrote:
> > Hm. Is this an oops or a lockdep warning?
> 
> It is a null-pointer dereference in sysfs_create_file(). Probably the
> kernel is asking the same question as I did - do you actually see the
> sysfs nodes when testing the patch?

Yup. Not sure what's happening there. I'll try to figure that out.

> > > So where to attach the sysfs nodes... There is also a userspace issue
> > > here, since a lot of applications are hard-wired to
> > > /sys/devices/platform/applesmc.768/.
> > 
> > The correct sysfs ABI is to use the /sys/class interface and the names 
> > under there rather than assuming a hardwired platform device path.
> 
> Still breaks user-space, but it seems this is already under control.

If it turns out that there's code that relies on it then we could 
obviously retain the platform device, but it's kind of ugly. sysfs 
paths aren't intended to be hardcoded.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
