Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab1KAOGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 10:06:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47315 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab1KAOGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 10:06:11 -0400
MIME-Version: 1.0
In-Reply-To: <4EAF1021.2090004@tlinx.org>
References: <4EAF1021.2090004@tlinx.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 1 Nov 2011 08:05:49 -0600
Message-ID: <CAErSpo4GaQfoBWs2iPk1ppx69Ccnz3dZvt31vSp8R7zka8a6=g@mail.gmail.com>
Subject: Re: ACPI ERROR SMBus or IPMI write requires Buff of len 66, found
 32...???? linux-3.0.0
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-acpi]

On Mon, Oct 31, 2011 at 3:16 PM, Linda Walsh <lkml@tlinx.org> wrote:
>
>
> Was looking through boot log messages, and this one seemed 'new'...

Can you confirm that this error did not occur on a previous version?
What is the most recent version where it did not occur?

> is this saying that the device requires 66, but the driver allocated 32
> bytes?
>
> Or the opposite: i.e. driver requires 66 (according to some new standard**)
> but the
> device from 2009, has the 2009 standard of 32?
>
> Just a WAG, but 20110413 looks like a date, that is certainly newer than the
> system, though
> it has had firmware upgrades (though none in the past 6 months or so...)...

20110413 is basically the version number of the ACPI CA in Linux.
Generally, we don't remove support for old things, so if it worked in
the past, it should still work with newer versions.

> Seems like a weird thing to be changed across drivers while not providing
> for some backward
> compat, but that's purely based on a notion that there's a driver/hw version
> mismatch now
> when before, there were no such error messages (maybe the error message is
> new, and it's
> always been broken? ;-) )...
>
> as subj says linux-3.0.0, stock vanilla + the latest IMQ networkfilter
> patch.
> X64
>
> [   13.722612] ACPI Error: SMBus or IPMI write requires Buffer of length 66,
> found length 32 (20110413/exfield-285)
> [   13.733078] ACPI Error: Method parse/execution failed [\_SB_.PMI0._GHL]
> (Node ffff880616962b18), AE_AML_BUFFER_LIMIT (20110413/psparse-536)
> [   13.746189] ACPI Error: Method parse/execution failed [\_SB_.PMI0._PMC]
> (Node ffff880616962a78), AE_AML_BUFFER_LIMIT
> [   13.755322] dca service started, version 1.12.1[   13.761822]
>  (20110413/psparse-536)
> [   13.765509] ACPI Exception: AE_AML_BUFFER_LIMIT, Evaluating _PMC
> (20110413/power_meter-773)

For completeness, it'd be nice to see the complete dmesg log.  In this
case, it looks AML-related, so an acpidump would also be useful.

Bjorn
