Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0GAX1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:27:44 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38315 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752925Ab0GAX1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:27:41 -0400
X-Sasl-enc: lCLZK+cIseEo28BhTvDnmvfAviB5nnxUPOFxsqNsUAZ6 1278026860
Date: Thu, 1 Jul 2010 20:27:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Renninger <trenn@suse.de>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, astarikovskiy@suse.de
Subject: Re: Provide /sys/../ec with read/write access and some cleanups
Message-ID: <20100701232737.GB15824@khazad-dum.debian.net>
References: <1277996570-2686-1-git-send-email-trenn@suse.de>
 <20100701162239.GB4789@khazad-dum.debian.net>
 <201007012144.27477.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007012144.27477.trenn@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Jul 2010, Thomas Renninger wrote:
> On Thursday 01 July 2010 06:22:39 pm Henrique de Moraes Holschuh wrote:
> > On Thu, 01 Jul 2010, Thomas Renninger wrote:
> > > These patches are diffed against the test branch of the ACPI tree, but
> > > also patch fine with 2.6.35-rc3.
> > >
> > > I thought about tainting the kernel if someone writes to the EC, but as
> > > userspace can also write to graphics IO, PCI config or MSRs, it shouldn't
> > > matter that much.
> > > Eventually this should still be added (by a separate patch), one can
> > > easily confuse the EC to not switch on the fans anymore.
> > >
> > > A small tool to read out and write to /sys/devices/system/ec/*/io can be
> > > found here:
> > > ftp://ftp.suse.com/pub/people/trenn/sources/ec/ec_access.c
> > >
> > > Len: Can you apply these into your test branch and schedule them for
> > > linux-next and 2.6.36 if there are no objections, please.
> >
> > I am just wondering if we shouldn't have this in debugfs instead of regular
> > /sys.  Do you envision *production* use of this facility, or should it just
> > be something to use for debugging and hacking?
> Only for debugging and hacking. Apps must not use it for production.
> On the one hand I agree, on the other hand side  I think the EC somehow
> fits into /sys/devices/system/ec. I don't have a strong opion on that, though.

You can have the ec metadata in sys, and the EC direct access in
debugfs, for example...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
