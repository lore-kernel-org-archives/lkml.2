Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab0GIPvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:51:24 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:33378 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab0GIPvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:51:21 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [RFC PATCH 1/1] PCI: skip release and reallocation of io port resources
Date: Fri, 9 Jul 2010 09:50:45 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ram Pai <linuxram@us.ibm.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       clemens@ladisch.de
References: <20100630211516.GA25991@us.ibm.com> <AANLkTiknAtUipCr64qwJXakD9VgqhHNp35KPq5x9_x8V@mail.gmail.com> <4C33CF1C.7020803@kernel.org>
In-Reply-To: <4C33CF1C.7020803@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007090950.47269.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 06, 2010 06:49:32 pm Yinghai Lu wrote:
> On 07/06/2010 04:58 PM, Linus Torvalds wrote:
> > On Tue, Jul 6, 2010 at 4:13 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >>
> >> So you want to use pci=override_bios to reallocate all bios assigned resource include
> >> peer root buses resources and pci bridge resource and pci devices BAR?
> > 
> > In a perfect world, we'd never need this at all, but sicne that's not
> > an option, the second-best alternative might be something like the
> > following:
> > 
> >   pci=override=off # default
> >   pci=override=conflict # override only on conflicts
> >   pci=override=<device> # clear BIOS allocations for <device> (and any
> > children, if it's a bus)
> 
> current:
> if there is conflict, like pci bridge resources or pci devices resources is not in the scope of peer root bus resource range.
> or pci devices is not in pci bridge resources range.
> kernel would reject the resource and try to get new range in parent resource for the children.
> 
> so current default is overriding the conflicts already.

One conflict we don't handle correctly is when we find a device that
doesn't fit inside the root bus resources.  We currently disable the
device, but Windows just leaves it where BIOS put it.

This causes this bug: https://bugzilla.kernel.org/show_bug.cgi?id=16263
It should be fairly simple to make Linux handle this conflict the same
way, without requiring any special kernel arguments.

Bjorn
