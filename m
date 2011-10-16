Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1JPE5f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 00:57:35 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56029 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1JPE5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 00:57:34 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 15 Oct 2011 22:57:12 -0600
X-Google-Sender-Auth: NnbXXkdE4Yp9WLfpuZ7ObQaD9jk
Message-ID: <CACxGe6u_LTgFtvbcULSECaWzOD7L_qhU+Wk2Fq-YMG7r2+GP+g@mail.gmail.com>
Subject: Working with ACPI and UEFI on ARM
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        boot-architecture@lists.linaro.org
Cc: David Rusling <david.rusling@linaro.org>,
        David Mandala <david.mandala@canonical.com>,
        Jeff Underhill <Jeff.Underhill@arm.com>, Jon Masters <jcm@redhat.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

We Linux developers seem to have a bit of a love-hate relationship
with ACPI.  On the plus side it provides the "standard platform" that
we rely on to support the huge amount of hardware in the x86 ecosystem
It is also the source of much pain due to firmware and DSDT tables
that are either buggy or perform poorly. In the embedded space we've
avoided ACPI entirely by standardizing on the Flattened Device Tree
for hardware discovery. However there are some market segments and use
cases where FDT doesn't solve the problems faced by OEMs, particularly
when the hardware needs to support existing, unmodified OS images.
Some OEMs are looking to implement ACPI on ARM since it is a solution
they are already familiar with. It's becoming clear to me that in the
near future, independent of whether or not we as the Linux community
like it, we are going to start seeing ARM systems that are based on
UEFI and ACPI.

But, to quote h2g2, "Don't Panic."  While there are many reasons as to
why ACPI has been the source of pain, at least one of those factors is
under our control.  Historically, we as the Linux community have not
been very good at participating or providing leadership as to what the
future of the commodity hardware industry should look like, and the
result is decisions that don't reflect our best interest, sheerly by
omission.  (There is an argument that standards setting hasn't been
inclusive either, but I have reason to hope that is neither permanent
nor insurmountable).

So, given that we know that ARM ACPI machines will exist, and given
that we still want to support Linux on these machines, I think it is
absolutely appropriate to start getting involved with both the ACPI
and UEFI standardization processes.  I (on behalf of Linaro) will soon
be joining the UEFI ARM Binding Sub Team (ABST), and we already have
representatives from Canonical and Red Hat involved there.  I'm also
investigating the possibility of getting involved when the post-ACPI 5
process begins, probably sometime early next year.

In the mean time, I want to start getting prepared by collecting
feedback about the state of ACPI and UEFI now, and what changes we
need to have for ACPI and UEFI to meet our needs in the Linux
ecosystem.  Reply to this email with your comments, and I'll start
collating a list that I can discuss with the ACPI and UEFI folks.

For your reference, the current versions of the ACPI and UEFI specs
can be found here[1][2].  The ACPI spec is freely downloadable, but
the UEFI spec requires a click-through license to read.

[1] http://www.acpi.info/DOWNLOADS/ACPIspec40a.pdf
[2] http://www.uefi.org/specs/


I'll kick things off with a few items from my personal list. This list
will grow as I collect feedback and input from all of you.

1) Open Process - Currently the ACPI definition process is entirely
confidential between the 5 APCI member companies (Microsoft, Intel,
Toshiba, HP and Phoenix Technologies), and it remains so until the
Final Draft is proposed to "Contributing Adopters" which is very late
in the process.  The current version of the spec is v4.0a[1]. ACPI 5
is currently under final review and will be released sometime late
2011, early 2012.

For us to participate in the ACPI definition, we need to have an open
processes so that open source Linux engineers can participate.

2) Improvements to compliance testing - Several Linux developers have
been doing good work on BIOS/UEFI/ACPI testing and are able to
identify many common bugs in firmware.  This is of course valueable to
the Linux ecosystem, but since it is discovering firmware bugs, it is
most likely of high value to all HW and OS vendors.  I would like to
see much of the test work that we're currently doing to start
filtering back into the tools that are routinely used by HW vendors as
part of QA testing.  Maybe even pushing for an industry wide suite of
compliance tests.

3) Better rules (and testing) on SMM interrupts (or the ARM
equivalent).  HW vendors are using SMM to work around hardware bugs or
perform system management tasks independently and transparently from
the operating system.  However, poorly implemented firmware will take
the processor away from the OS for unbounded periods of time which is
a deal breaker for any kind of real-time response in the OS.  For ARM
systems I would like to see an alternative to compete interruption of
the OS when firmware needs to perform system management tasks.

Cheers,
g.
