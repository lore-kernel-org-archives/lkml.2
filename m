Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab0GIQA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 12:00:29 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:44723 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757397Ab0GIQA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 12:00:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=FK2ghgVDtgwAYCRYlniaCf5/RgfsvOKZ3ivMAO/M8uxhkVcGlpQqzVMh91x05mK2Z2cZcquC946KkOy2BHpwdmiCiYvtbiOkqMLUne1oNnBKbhbK78trcYfh96A9MwqA;
Date: Fri, 9 Jul 2010 09:00:07 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ram Pai <linuxram@us.ibm.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, clemens@ladisch.de
Subject: Re: [RFC PATCH 1/1] PCI: skip release and reallocation of io port
 resources
Message-ID: <20100709090007.38b0fffc@virtuousgeek.org>
In-Reply-To: <201007090950.47269.bjorn.helgaas@hp.com>
References: <20100630211516.GA25991@us.ibm.com>
	<AANLkTiknAtUipCr64qwJXakD9VgqhHNp35KPq5x9_x8V@mail.gmail.com>
	<4C33CF1C.7020803@kernel.org>
	<201007090950.47269.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010 09:50:45 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Tuesday, July 06, 2010 06:49:32 pm Yinghai Lu wrote:
> > On 07/06/2010 04:58 PM, Linus Torvalds wrote:
> > > On Tue, Jul 6, 2010 at 4:13 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > >>
> > >> So you want to use pci=override_bios to reallocate all bios assigned resource include
> > >> peer root buses resources and pci bridge resource and pci devices BAR?
> > > 
> > > In a perfect world, we'd never need this at all, but sicne that's not
> > > an option, the second-best alternative might be something like the
> > > following:
> > > 
> > >   pci=override=off # default
> > >   pci=override=conflict # override only on conflicts
> > >   pci=override=<device> # clear BIOS allocations for <device> (and any
> > > children, if it's a bus)
> > 
> > current:
> > if there is conflict, like pci bridge resources or pci devices resources is not in the scope of peer root bus resource range.
> > or pci devices is not in pci bridge resources range.
> > kernel would reject the resource and try to get new range in parent resource for the children.
> > 
> > so current default is overriding the conflicts already.
> 
> One conflict we don't handle correctly is when we find a device that
> doesn't fit inside the root bus resources.  We currently disable the
> device, but Windows just leaves it where BIOS put it.
> 
> This causes this bug: https://bugzilla.kernel.org/show_bug.cgi?id=16263
> It should be fairly simple to make Linux handle this conflict the same
> way, without requiring any special kernel arguments.

Sounds reasonable.  I'm open to suggestions on alternate approaches for
this issue as well.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
