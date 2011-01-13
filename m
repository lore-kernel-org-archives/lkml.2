Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab1AMSwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 13:52:44 -0500
Received: from www.tglx.de ([62.245.132.106]:50550 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab1AMSwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 13:52:41 -0500
Date: Thu, 13 Jan 2011 19:51:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@amd64.org>
cc: Manoj Iyer <manoj.iyer@canonical.com>, Matthew Garrett <mjg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
In-Reply-To: <20110113183025.GE2006@aftab>
Message-ID: <alpine.LFD.2.00.1101131946560.2678@localhost6.localdomain6>
References: <1294934542-2411-1-git-send-email-manoj.iyer@canonical.com> <1294934542-2411-2-git-send-email-manoj.iyer@canonical.com> <20110113164616.GB21289@srcf.ucam.org> <alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6> <20110113172205.GA30866@kryptos.osrc.amd.com>
 <AANLkTinw23rtSERxAy6G_cu5=rvQeEzxvf3snsUOZE+z@mail.gmail.com> <20110113175531.GD2006@aftab> <AANLkTikDoRMoQjtN03eMoeacwottEixrFqcF8nJZWgKy@mail.gmail.com> <20110113183025.GE2006@aftab>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Borislav Petkov wrote:

> On Thu, Jan 13, 2011 at 01:11:48PM -0500, Manoj Iyer wrote:
> > Borislav,
> > 
> > Please see attached lspci output.
> 
> Thanks, that looks better. A stab in the dark:
> 
> Can you boot your machine with "nohpet" and try a suspend/resume cycle
> to see whether that helps?
> 
> If that works, can you then boot normally (i.e. no "nohpet" option on
> the command line) and wait ~5mins after resume to see whether your
> machine comes out of the hang after all (the idea here is to wait for
> the 32bit HPET counter to wrap around).

What's odd is that the machines actually boot. I would have expected
that they do not boot at all if the BIOS IRQ0 pin2 override is
ignored. But it seems that takes effect just when the machine does a
suspend/resume. Weird!

Can we please get a dmesg for a boot with an unpatched kernel and one
with the DMI quirks applied (or acpi_skip_timer_override on the kernel
command line) ?

Thanks,

	tglx
