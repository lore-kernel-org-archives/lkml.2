Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2LEAG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 19:06:59 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52862 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab2LEAG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 19:06:57 -0500
MIME-Version: 1.0
In-Reply-To: <1962888.rQgbRUetgj@vostro.rjw.lan>
References: <1353398902-21253-1-git-send-email-ying.huang@intel.com>
 <CAErSpo6CPSMXjq1eSTX41vtwOcd5rQOdC0-9ye5NZhds9U1B8A@mail.gmail.com> <1962888.rQgbRUetgj@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 4 Dec 2012 17:06:36 -0700
Message-ID: <CAErSpo5gLgcLcvWPGPMivYqGKBdyjsFgKtOVreCj4FO1P__Vgg@mail.gmail.com>
Subject: Re: [PATCH] PCI/PM: Keep runtime PM enabled for unbound PCI devices
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 3:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, November 28, 2012 03:25:59 PM Bjorn Helgaas wrote:
>> On Tue, Nov 20, 2012 at 1:08 AM, Huang Ying <ying.huang@intel.com> wrote:
>> > For unbound PCI devices, what we need is:
>> >
>> >  - Always in D0 state, because some devices does not work again after
>> >    being put into D3 by the PCI bus.
>> >
>> >  - In SUSPENDED state if allowed, so that the parent devices can still
>> >    be put into low power state.
>> >
>> > To satisfy these requirement, the runtime PM for the unbound PCI
>> > devices are disabled and set to SUSPENDED state.  One issue of this
>> > solution is that the PCI devices will be put into SUSPENDED state even
>> > if the SUSPENDED state is forbidden via the sysfs interface
>> > (.../power/control) of the device.  This is not an issue for most
>> > devices, because most PCI devices are not used at all if unbounded.
>> > But there are exceptions.  For example, unbound VGA card can be used
>> > for display, but suspend its parents make it stop working.
>> >
>> > To fix the issue, we keep the runtime PM enabled when the PCI devices
>> > are unbound.  But the runtime PM callbacks will do nothing if the PCI
>> > devices are unbound.  This way, we can put the PCI devices into
>> > SUSPENDED state without put the PCI devices into D3 state.
>>
>> Does this fix a reported problem?  Is there a bug report URL?  What
>> problem would a user notice?
>
> There is a BZ: https://bugzilla.kernel.org/show_bug.cgi?id=48201

I added the BZ link and put this in my -next branch.  Thanks!

Bjorn
