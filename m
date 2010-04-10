Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab0DJHCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 03:02:16 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:42623 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab0DJHBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 03:01:51 -0400
Date: Sat, 10 Apr 2010 08:41:39 +0200
From: Harald Welte <laforge@gnumonks.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       linux-kernel@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 02/16] viafb: use proper pci config API
Message-ID: <20100410064139.GS14576@prithivi.gnumonks.org>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
 <1270746946-12467-3-git-send-email-corbet@lwn.net>
 <4BBE2389.5010802@gmx.de>
 <20100409134610.0b610f93@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100409134610.0b610f93@bike.lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon + Florian,

On Fri, Apr 09, 2010 at 01:46:10PM -0600, Jonathan Corbet wrote:
> On Thu, 08 Apr 2010 20:42:17 +0200
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> 
> > something I am wondering about is whether we can't simply do:
> > viaparinfo->memsize = pci_resource_len(pdev, 0);
> > I suppose that this is not possible meaning that the pci len can be 
> > longer than the actual memory but I just wanted to use the moment to 
> > make sure.
> 
> That would make sense.  But if somebody who is closer to the hardware than
> I am doesn't take that approach, I'm nervous about changing it.  Harald?

I believe it is not safe to simply use the pci_resource_len(pdev, 0).

At least in some of the hardware I've been working with in the past, the
PCI resource length was always fixed, independent of how large the BIOS
configured the shared video memory.

So please don't use that method.

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
