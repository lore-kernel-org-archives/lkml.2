Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab0GHXMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:12:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61238 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758801Ab0GHXMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:12:40 -0400
MIME-Version: 1.0
Message-ID: <592dc9b4-d329-4ce3-a5a1-9e6e7044b90c@default>
Date: Thu, 8 Jul 2010 16:12:01 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Andi Kleen <andi@firstfloor.org>, Daniel Kiper <dkiper@net-space.pl>
Cc: jeremy@goop.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org
Subject: RE: [Xen-devel] Re: GSoC 2010 - Migration from memory ballooning to
 memory hotplug in Xen
References: <20100708194553.GA30124@router-fw-old.local.net-space.pl
 871vbdr4ey.fsf@basil.nowhere.org>
In-Reply-To: <871vbdr4ey.fsf@basil.nowhere.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C365B51.0089:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andi Kleen [mailto:andi@firstfloor.org]
> 
> Daniel Kiper <dkiper@net-space.pl> writes:
> >
> > OK, let's go to details. When I was playing with Xen I saw that
> > ballooning does not give possibility to extend memory over boundary
> > declared at the start of system. Yes, I know that is by desing
> however
> > I thought that it is a limitation which could by very annoing in some
> > enviroments (I think especially about servers). That is why I decided
> to
> > develop some code which remove that one. At the beggining I thought
> > that it should be replaced by memory hotplyg however after some test
> > and discussion with Jeremy we decided to link balooning (for memory
> > removal) with memory hotplug (for extending memory above boundary
> > declared at the startup of system). Additionaly, we decided to
> implement
> > this solution for Linux Xen gustes in all forms (PV/i386,x86_64 and
> > HVM/i386,x86_64).
> 
> While you can do that the value is not very large because you
> could just start the guests with more memory, but ballooned in
> the first place (so that they don't actually use it)
> 
> The only advantage of using memory hotadd is that the mem_map doesn't
> need to be pre-allocated, but that's only a few percent of the memory.
> 
> So it would only help if you want to add gigantic amounts of memory
> to a VM (like >20-30x of what it already has).

One can envision a scenario where a cloud customer launches a
business-critical VM with some reasonably large "maxmem" set,
balloons up to the max, then finds out it isn't enough after
all and would like to avoid rebooting.  Or a cloud provider
might charge for a specific maxmem, but allow the customer
to increase maxmem if they pay more money.

Dan
