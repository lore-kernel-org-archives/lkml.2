Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab2IFUaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:30:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35561 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759831Ab2IFUav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:30:51 -0400
Date: Thu, 6 Sep 2012 13:28:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Chris Zankel <chris@zankel.net>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] Turn CONFIG_HOTPLUG always on.
Message-ID: <20120906202815.GA6732@kroah.com>
References: <20120904234803.554552301@clark.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904234803.554552301@clark.kroah.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 05:01:05PM -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> 
> The CONFIG_HOTPLUG variable is tough to turn off, and almost all arches
> default to it on.
> 
> If you turn it off, it saves you a big 200 or so bytes, and then starts
> to cause all sorts of problems as the code paths if the option is
> disabled is never really tested, and memory segments start to get thrown
> away that driver authors assume will always be present.
> 
> So, as part of trying to get rid of the option entirely, let's just turn
> the option always on.
> 
> Note, to do this properly, I found two duplicate definitions of the
> option, in the Tile and Xtensa arch files, this patch series removes
> those duplicates first.
> 
> Anyone object to me just taking these three patches through my
> driver-core tree for 3.7?  After this set, I'll start unwinding the
> places where CONFIG_HOTPLUG is used and remove the parts that are not
> used anymore now that the option can not be turned off.

Given the lack of objection, I've now queued these up for 3.7 and will
start unwinding the CONFIG_HOTPLUG mess.

thanks,

greg k-h
