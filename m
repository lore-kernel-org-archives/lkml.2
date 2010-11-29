Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0K2VgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:36:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53566 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0K2VgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:36:13 -0500
Message-ID: <4CF41C89.9060708@zytor.com>
Date: Mon, 29 Nov 2010 13:35:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] x86/PCI: never allocate PCI space from the last 1M below
 4G
References: <20101129183009.11256.33739.stgit@bob.kio> <201011291334.52909.bjorn.helgaas@hp.com> <4CF3F62F.2000508@zytor.com> <201011291432.51264.bjorn.helgaas@hp.com>
In-Reply-To: <201011291432.51264.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 01:32 PM, Bjorn Helgaas wrote:
> 
> Oops, egg on my face.  In this case, there *is* an ACPI INT0800 device
> at 0xff000000-0xffffffff, which should prevent us from allocating that
> space for anything else.  Only problem is, we IGNORE that useful bit of
> information.
> 

Eep... why?

>> It is certainly reasonable to block off the last chunk of the 32-bit
>> address space.  Some systems double-decode it to avoid issues with
>> A20M#, so I would argue that we should avoid at least 2 MiB.
>>
>> As far as discovering them from the BIOS, there is a way to do it --
>> E820.  This is a fallback for the case where the BIOS has plain and
>> simply failed to provide it, and so a heuristic is probably the best we
>> can do.  Probing is extremely unsafe.
> 
> I think it's clearly a bug that Linux ignores ACPI resource information
> (except PNP0C01/PNP0C02 motherboard devices).  If we fix that bug, it
> will fix Matthew's 2530p.

I would definitely agree with that.

> We might still want a patch like this current one because it could
> work around some BIOS defects, and because I think it's too late to
> fix the ACPI resource problem for .37.  But I'm not convinced we
> should reserve more than Windows does, because that may keep us from
> discovering other important Linux problems.

I'm not so sure about that... it feels like a pretty weak argument that
we might work on some machines even though our code isn't perfect.

	-hpa
