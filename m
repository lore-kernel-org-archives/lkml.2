Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab0IVUUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:20:37 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:9761 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0IVUUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:20:36 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH] x86, HPET: ignore any PCI BARs that match an HPET we already know about
Date: Wed, 22 Sep 2010 14:19:36 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: Prarit Bhargava <prarit@redhat.com>, Simon Arlott <simon@fire.lp0.eu>,
        x86@kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        linux-kernel@vger.kernel.org, Marc Jones <marcj303@gmail.com>,
        Jordan Crouse <jcrouse@codeaurora.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20100922201547.3197.33702.stgit@bob.kio>
In-Reply-To: <20100922201547.3197.33702.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009221419.47283.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 22, 2010 02:15:47 pm Bjorn Helgaas wrote:
> 
> We often discover the HPET early, via the static ACPI HPET table, before
> enumerating PCI devices.  If the HPET is implemented as a PCI function,
> we will discover it again during PCI device enumeration.  We must ignore
> the PCI function so we don't inadvertently move it out from under the
> driver.
> 
> I think it's better to ignore *any* PCI BAR that matches a previously
> discovered HPET; that way we don't need platform-specific knowledge,
> and we won't have to add more quirks for future machines.
> 
> This is for a regression from 2.6.34, but the reporter has been
> unable to test it yet.
> 
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=18482

I've tried hard to find somebody who can test this, but nobody who
can reproduce the original failure has been able to test it.  I
propose that we put it in linux-next and see what happens there.

Bjorn
