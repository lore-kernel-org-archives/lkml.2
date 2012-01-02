Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab2ABP52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 10:57:28 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50173 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2ABP5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 10:57:25 -0500
Date: Mon, 2 Jan 2012 15:57:11 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tejun Heo <tj@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, kay.sievers@vrfy.org
Subject: Re: [RFC][PATCH 4/4] ahci: support hot plug when port/controller
 is runtime suspended
Message-ID: <20120102155711.GA10202@srcf.ucam.org>
References: <1323954769-3918-1-git-send-email-ming.m.lin@intel.com>
 <1323954769-3918-5-git-send-email-ming.m.lin@intel.com>
 <20111215192131.GE32002@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215192131.GE32002@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 11:21:31AM -0800, Tejun Heo wrote:

> SATA link detection requires hot wire and keeping wire hot takes
> power.  I think it's fair tradeoff to not support hotplug while
> powersaving is on.  We have warm plug mechanism (the SCSI rescan
> trigger via sysfs) after all.  It would be nice if things like that is
> somehow exported to userland in easy way tho (cc'ing Kay), but I
> frankly don't have much idea where that would fit.

We expose the ahci_port_cmd field in sysfs, which lets us know whether a 
port is flagged as hotpluggable or external. Userspace could use that to 
identify whether a given port can be safely powered off or not. It's not 
guaranteed - desktop boards with esata ports will typically not have 
this information available (because the esata port could be plugged into 
any on-board port), so I think leaving it up to userspace to set the 
policy makes sense.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
