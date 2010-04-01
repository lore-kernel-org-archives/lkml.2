Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab0DACCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:02:55 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:57202 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab0DACCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 22:02:53 -0400
Date: Wed, 31 Mar 2010 22:02:33 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-acpi@vger.kernel.org, Iranna D Ankad <iranna.ankad@in.ibm.com>,
       Gary Hade <garyhade@us.ibm.com>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: [PATCH 0/14] Start coping gsis < 16 that are not isa irqs.
In-reply-to: <m1r5n2wwah.fsf_-_@fess.ebiederm.org>
Message-id: <alpine.LFD.2.00.1003312154180.13993@localhost.localdomain>
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
 <1269221770-9667-3-git-send-email-yinghai@kernel.org>
 <alpine.LFD.2.00.1003221131470.3147@localhost.localdomain>
 <m1iq8f1c1f.fsf@fess.ebiederm.org> <4BB0EA22.7000004@zytor.com>
 <m1r5n2wwah.fsf_-_@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It appears there are a few systems in the wild that use acpi
> interrupt source overrides to report a gsi > 16 is an isa irq.
> 
> This breaks all kinds of assumptions I figure any BIOS doing that
> probably should be shot as that is very much not a conservative position.

You might run into trouble here on the ES7000 -- though I don't know
if anybody is booting a modern kernel on one of those these days.

IIR, ES7000 treated the bottom 16 as a special case.
When there was an irq shortage, I think they used overrides
to map higher PCI irqs into the empty spots below 16,
but I think to make room for them they may have mapped
some of the ISA irqs to high numbers.  Fuzzy memory
on this at the moment...

cheers,
Len Brown, Intel Open Source Technology Center

