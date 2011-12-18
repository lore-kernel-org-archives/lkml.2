Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab1LRS74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 13:59:56 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36479 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab1LRS7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 13:59:52 -0500
MIME-Version: 1.0
In-Reply-To: <1324142068.2825.341.camel@deadeye>
References: <1324142068.2825.341.camel@deadeye>
Date: Sun, 18 Dec 2011 10:59:50 -0800
Message-ID: <CAA9_cmd9KMS3UBsQJ0WxT0rtQJVWceVwxvyXtRD+PuzwjUHUGA@mail.gmail.com>
Subject: Re: [RFC][PATCH linux-firmware] isci: Add firmware blob and sources
From: Dan Williams <dan.j.williams@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 17, 2011 at 9:14 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> isci requires a parameter blob which is usually found in NVRAM, but it
> can fall back to loading with request_firmware().  These files are
> taken from the Linux source tree where they were wrongly added in
> Linux 3.0.

Oh, I was of the impression that the external firmware tree was for
license incompatible firmware images?

> ---
> I'm a bit unclear on the purpose and use of isci_firmware.bin.  Is it
> needed for production hardware?

It's a stop gap for platforms with missing or broken oem parameters.
It is meant to become vestigial once the platform revisions quiet
down.

> Does it need to be customised
> per-system, or are module parameters sufficient for that?  (If not, why
> isn't it built into the driver?)

It is customized per system to meet EMI and signal integrity targets
of a given platform.

> probe_roms.h is labelled with a dual BSD/GPLv2 licence but the other
> files had no licence header so I've treated them as GPLv2 by default.

The latest version of probe_roms.h [1] supports the v1.3 oem parameter
format, this patch appears to be v1.0 based.

Regards,
Dan

[1]: http://git.kernel.org/?p=linux/kernel/git/djbw/isci.git;a=blob;f=drivers/scsi/isci/probe_roms.h;hb=refs/heads/fixes
