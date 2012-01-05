Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab2AEVah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:30:37 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35640 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758304Ab2AEVaf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:30:35 -0500
MIME-Version: 1.0
In-Reply-To: <20120105212724.3965.30193.stgit@bhelgaas.mtv.corp.google.com>
References: <20120105212719.3965.40406.stgit@bhelgaas.mtv.corp.google.com> <20120105212724.3965.30193.stgit@bhelgaas.mtv.corp.google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 5 Jan 2012 14:30:13 -0700
Message-ID: <CAErSpo6=yHFspY_L0rQa6iVD692nYyL=BR=3qBwc3UV8M16xbw@mail.gmail.com>
Subject: Re: [PATCH 2/2] PNP: work around Dell 1536/1546 BIOS MMCONFIG bug
 that breaks USB
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: thuban@singularity.fr, dann frazier <dann.frazier@canonical.com>,
        Lisa Salimbas <lisa.salimbas@canonical.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 2:27 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> Some Dell BIOSes have MCFG tables that don't report the entire
> MMCONFIG area claimed by the chipset.  If we move PCI devices into
> that claimed-but-unreported area, they don't work.
>
> This quirk reads the AMD MMCONFIG MSRs and adds PNP0C01 resources as
> needed to cover the entire area.

PNP stuff usually goes through Len's ACPI tree, but this is really
x86-specific, and these two patches need to go together, so I think it
would make sense to put them both in the x86 tree.  Len, do you
object?

Bjorn
