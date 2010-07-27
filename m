Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0G0Rl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:41:29 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:21084 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab0G0Rl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:41:28 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] ipmi: Fix ACPI detecting with regspacing
Date: Tue, 27 Jul 2010 11:41:10 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: Corey Minyard <minyard@acm.org>, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Myron Stowe <myron.stowe@hp.com>,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <4C4E0292.4010004@kernel.org> <201007271123.44335.bjorn.helgaas@hp.com> <4C4F173C.1010406@kernel.org>
In-Reply-To: <4C4F173C.1010406@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007271141.10933.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 27, 2010 11:28:28 am Yinghai Lu wrote:
> On 07/27/2010 10:23 AM, Bjorn Helgaas wrote:
> > On Tuesday, July 27, 2010 11:07:55 am Yinghai Lu wrote:
> >> On 07/27/2010 08:34 AM, Bjorn Helgaas wrote:
> >>> On Monday, July 26, 2010 03:48:02 pm Yinghai Lu wrote:
> >>>>
> >>>> after the commint that change ipmi_si detecting sequence from SMBIOS/ACPI to ACPI/SMBIOS,
> >>>>
> >>>> | commit 754d453185275951d39792865927ec494fa1ebd8
> >>>> | Author: Matthew Garrett <mjg@redhat.com>
> >>>> | Date:   Wed May 26 14:43:47 2010 -0700
> >>>> |
> >>>> |    ipmi: change device discovery order
> >>>> |
> >>>> |    The ipmi spec provides an ordering for si discovery.  Change the driver to
> >>>> |    match, with the exception of preferring smbios to SPMI as HPs (at least)
> >>>> |    contain accurate information in the former but not the latter.
> >>>>
> >>>> ipmi_si can not be initialized.
> >>>
> >>> I think this patch makes sense, as long as this is not a bringup
> >>> issue that only affects pre-release firmware.  If this only affects
> >>> a prototype, it would be better to change the firmware so it conforms
> >>> to the conventional _CRS usage of systems in the field.
> >>>
> >>> To that end, I'd like to know what system this is, and whether IPMI
> >>> works under Windows on this system.  We know that Windows doesn't
> >>> look at SMBIOS or SPMI, so if Windows works, it must be doing something
> >>> similar to your patch.
> >>
> >> Sun Fire X4800.
> >>
> >> Yes. other OSes work and pass certification.
> > 
> > Please put this information in the changelog (if that wasn't obvious).
> 
> I don't want to mention other os.

Sigh.  Why is this so difficult?

It's very useful to know which other OSes work and *how* they work.
If another OS (particularly a popular one like Windows) works, and we
know it's using the ACPI namespace, that tells us we need a change
like yours.  If another OS works but is using SPMI, that tells us
nothing about whether we should make this change.

If no other OS uses the namespace, then we might be adding a Linux
change just to deal with a firmware defect on this machine, and that
sort of change could easily break other machines.

I don't think that's the case here; I think we *should* make the
change you're proposing.  But it's just a good practice to be
diligent about documenting the reasons for the changes we make.

Bjorn
