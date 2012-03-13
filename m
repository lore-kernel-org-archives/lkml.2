Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793Ab2CMGDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:03:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32800 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759692Ab2CMGDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:03:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5cCC4HySedQ85BFKkPQ0VuYWX+NTjZLd4GpcATh1ix3g@mail.gmail.com>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
	<1331362837-10740-24-git-send-email-yinghai@kernel.org>
	<CAErSpo5cCC4HySedQ85BFKkPQ0VuYWX+NTjZLd4GpcATh1ix3g@mail.gmail.com>
Date: Mon, 12 Mar 2012 23:03:30 -0700
X-Google-Sender-Auth: qDlVNs838Ue_pj6Qn6-YFeNcoFg
Message-ID: <CAE9FiQWvOpJ1N=QLQ3MHRqVGw7pz1Fuma60pJSwzqP5Jc5PF3Q@mail.gmail.com>
Subject: Re: [PATCH v2 23/37] PCI, ACPI: Add pci_root_hp hot add hotplug notification
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 8:22 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sat, Mar 10, 2012 at 12:00 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> It is from acpiphp_glue.c
>>
>> How to use it?
>> Find out root bus number to acpi root name mapping from dmesg or /sys
>>
>>  echo "\_SB.PCIB 0" > /proc/acpi/sci/notify
>> to add it back
>
> Nope.  That might be a way to exercise this for debug purposes (and it
> only works when /proc/acpi/sci/notify is compiled in), but we
> definitely don't want normal users to deal with ACPI pathnames like
> this.

before this patch set, only way is: Users really put one root bus in
and press buton etc to trigger notification
to get it work.

>
> Most of this functionality belongs in the ACPI core, not here.  The
> core should be handling these notify events and turning them into
> .add() and .remove() calls to the driver.
>
> But since the ACPI core doesn't do that yet, we have to do it in the
> driver, like we do for CPU, memory, etc.  That part is fine.  But I
> think it at least belongs *in* the driver, i.e., in pci_root.c, not in
> a new pci_root_hp.c file.

don't want to pollute pci_root.c.

in separated file, we can use CONFIG_HOTPLUG in Makefile instead of pci_root.c

>
> There definitely should not be another acpi_walk_namespace() and
> another list of ACPI host bridges.  The core *does* already walk the
> namespace and call acpi_pci_root_add() for us.  And the driver already
> has a list of host bridges (acpi_pci_roots).

no, we may not have acpi_pci_root there.
