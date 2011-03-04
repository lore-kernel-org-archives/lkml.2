Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223Ab1CDVa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:30:27 -0500
Received: from kroah.org ([198.145.64.141]:38808 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760096Ab1CDVaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:30:25 -0500
Date: Fri, 4 Mar 2011 13:27:09 -0800
From: Greg KH <greg@kroah.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, security@kernel.org,
        linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [Security] [PATCH] power: disable hibernation if module
 loading is disabled
Message-ID: <20110304212709.GA28680@kroah.com>
References: <1299255084-4390-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299255084-4390-1-git-send-email-segoon@openwall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 07:11:24PM +0300, Vasiliy Kulikov wrote:
> If /proc/sys/kernel/modules_disabled is set to 1, then nobody (even full
> root) may not read/write arbitrary kernel memory.  In spite of it,
> hibernation allows anyone with an access to either /dev/snapshot or
> /sys/power/ make the full snapshot of the system.  This snapshot may be
> freely changed and uploaded back.

This sounds like a very unintentional change to the "don't load any
modules" option, right?  If so, you should really document this
somewhere, otherwise people are going to get very confused when their
system suspends suddenly stop working for no obvious reason.

thanks,

greg k-h
