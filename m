Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab1KKJtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 04:49:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62254 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab1KKJtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 04:49:04 -0500
MIME-Version: 1.0
In-Reply-To: <1320961113-5050-1-git-send-email-mjg@redhat.com>
References: <1320961113-5050-1-git-send-email-mjg@redhat.com>
Date: Fri, 11 Nov 2011 10:49:02 +0100
Message-ID: <CACna6rwxWUtfa2uz1hXVUthSpJF6SKP3V-ERt0=3oVQ2KKEo=g@mail.gmail.com>
Subject: Re: [PATCH] pci: Rework ASPM disable code
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/10 Matthew Garrett <mjg@redhat.com>:
> Right now we forcibly clear ASPM state on all devices if the BIOS indicates
> that the feature isn't supported. Based on the Microsoft presentation
> "PCI Express In Depth for Windows Vista and Beyond", I'm starting to think
> that this may be an error. The implication is that unless the platform
> grants full control via _OSC, Windows will not touch any PCIe features -
> including ASPM. In that case clearing ASPM state would be an error unless
> the platform has granted us that control.
>
> This patch reworks the ASPM disabling code such that the actual clearing
> of state is triggered by a successful handoff of PCIe control to the OS.
> The general ASPM code undergoes some changes in order to ensure that the
> ability to clear the bits isn't overridden by ASPM having already been
> disabled. Further, this theoretically now allows for situations where
> only a subset of PCIe roots hand over control, leaving the others in the
> BIOS state.
>
> It's difficult to know for sure that this is the right thing to do -
> there's zero public documentation on the interaction between all of these
> components. But enough vendors enable ASPM on platforms and then set this
> bit that it seems likely that they're expecting the OS to leave them alone.
>
> Measured to save around 5W on an idle Thinkpad X220.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Does it make sense to CC stable? To get it into 2.6.38+?

-- 
Rafał
