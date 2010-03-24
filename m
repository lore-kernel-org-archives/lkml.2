Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab0CXQZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:25:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389Ab0CXQZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:25:50 -0400
Date: Wed, 24 Mar 2010 09:26:16 -0700
From: Greg KH <gregkh@suse.de>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pavan Savoy <pavan_savoy@yahoo.co.in>, PavanSavoy <pavan_savoy@ti.com>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
Message-ID: <20100324162616.GA9257@suse.de>
References: <359814.2971.qm@web94904.mail.in2.yahoo.com> <1269447105.11714.117.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269447105.11714.117.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 09:11:45AM -0700, Marcel Holtmann wrote:
> > I wanted to somehow put this in staging because then it would probably have a thorough architectural review process.
> > Some details about this driver - 
> > 
> > 1. This driver will be used by Bluetooth-BlueZ/FM-V4L2 and GPS (probably character device driver) using the EXPORTED symbols (-register/_unregister).
> > 
> > 2. Much like the hciattach daemon which maintains N_HCI bluetooth line discipline, this driver will also have a User-Space  N_TI_WL Init manager (UIM) maintaining the Line discipline.
> 
> can you explain why you think this is needed and we can not interface
> this directly. If it is a serial port, what protocol does it talk?
> 
> > 3. Because of the UIM should know when to install/uninstall line discipline, the /sys entry is created a root called UIM (a new kobject) and UIM daemon would write it's PID to it.
> 
> I don't understand this. This sounds like a broken concept to me.

I also agree, those sysfs files are not acceptable, and will not work
as-designed due to the pid namespace issues :(

thanks,

greg k-h
