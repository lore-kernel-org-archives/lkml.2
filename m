Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab1JPSMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 14:12:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab1JPSMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 14:12:39 -0400
Subject: Re: Working with ACPI and UEFI on ARM
From: Jon Masters <jcm@redhat.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        boot-architecture@lists.linaro.org,
        David Rusling <david.rusling@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Mandala <david.mandala@canonical.com>,
        Jeff Underhill <Jeff.Underhill@arm.com>
In-Reply-To: <CACxGe6u_LTgFtvbcULSECaWzOD7L_qhU+Wk2Fq-YMG7r2+GP+g@mail.gmail.com>
References: <CACxGe6u_LTgFtvbcULSECaWzOD7L_qhU+Wk2Fq-YMG7r2+GP+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat, Inc.
Date: Sun, 16 Oct 2011 14:08:00 -0400
Message-ID: <1318788480.5538.22.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Thank you very much for starting this conversation on LKML.

On Sat, 2011-10-15 at 22:57 -0600, Grant Likely wrote:

<snip>

> there are some market segments and use cases where FDT doesn't solve
> the problems faced by OEMs, particularly when the hardware needs to
> support existing, unmodified OS images. Some OEMs are looking to
> implement ACPI on ARM since it is a solution they are already familiar
> with. It's becoming clear to me that in the near future, independent of
> whether or not we as the Linux community like it, we are going to start
> seeing ARM systems that are based on UEFI and ACPI.

Right. To add to this, I don't think anyone is suggesting by UEFI that
we'll see lots of runtime services implemented in UEFI on ARM, but we
will be seeing systems that boot with UEFI. Personally, I like this for
general purpose OS environments as opposed to using one of the many
different U-Boots out there, none of which handle generically installing
an OS and having a standard discoverable location for kernel and
initramfs images, and upgrading all of these bits automatically. That's
not to disparage U-Boot, just to say it targets a different use case.

<snip>

> Historically, we as the Linux community have not been very good at
> participating or providing leadership as to what the future of the
> commodity hardware industry should look like, and the result is
> decisions that don't reflect our best interest, sheerly by omission.

Right. I think this is key. ACPI isn't "evil". It's an evolved standard
that we've not been really engaged in steering or developing, and that
is beginning to change. I am encouraged to believe that the future is
bright as far as having more constructive input, especially post 5.

> I (on behalf of Linaro) will soon be joining the UEFI ARM Binding
> Sub Team (ABST), and we already have representatives from Canonical
> and Red Hat involved there.

On our side, I am already a member of the UEFI ARM Binding Sub Team and
have at least reviewed all of the existing standards documentation.

> I'm also investigating the possibility of getting involved when the
> post-ACPI 5 process begins, probably sometime early next year.

Indeed. I have been able to review existing ACPI drafts but the current
structure can certainly be improved in the future to be more inclusive
during the actual definition of these standards if we are to use them.
We have a unique opportunity to help steer here by acknowledging the
interest in ACPI and responding by asking for things in return.

<snip>

> I'll kick things off with a few items from my personal list.

I'll followup with a few of the things I've been thinking about.

<snip>

> 3) Better rules (and testing) on SMM interrupts (or the ARM
> equivalent).  HW vendors are using SMM to work around hardware bugs or
> perform system management tasks independently and transparently from
> the operating system.  However, poorly implemented firmware will take
> the processor away from the OS for unbounded periods of time which is
> a deal breaker for any kind of real-time response in the OS.  For ARM
> systems I would like to see an alternative to compete interruption of
> the OS when firmware needs to perform system management tasks.

Right. At the moment, it's looking like TrustZone will be one way in
which SMM-like things are done. It's more of a general platform issue
than specific to ACPI or UEFI but it is one of the areas to look at.

Jon.


