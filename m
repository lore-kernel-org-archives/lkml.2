Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab2HEKC0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 06:02:26 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39435 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2HEKCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 06:02:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120723173415.5b80b28b@endymion.delvare>
References: <20120723173415.5b80b28b@endymion.delvare>
Date: Sun, 5 Aug 2012 12:02:25 +0200
Message-ID: <CACRpkdauixNKja44nC13Cwr-023uVwZ54Y-9pJTCTOSGQH+6cw@mail.gmail.com>
Subject: Re: [PATCH] gpio-ich: Share ownership of GPIO groups
From: Linus Walleij <linus.walleij@linaro.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Peter Tyser <ptyser@xes-inc.com>, Aaron Sierra <asierra@xes-inc.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 5:34 PM, Jean Delvare <khali@linux-fr.org> wrote:

> The ICH chips have their GPIO pins organized in 2 or 3 independent
> groups of 32 GPIO pins. It can happen that the ACPI BIOS wants to make
> use of pins in one group, preventing the OS to access these. This does
> not prevent the OS from accessing the other group(s).
>
> This is the case for example on my Asus Z8NA-D6 board. The ACPI BIOS
> wants to control GPIO 18 (group 1), while I (the OS) need to control
> GPIO 52 and 53 (group 2) for SMBus multiplexing.
>
> So instead of checking for ACPI resource conflict on the whole I/O
> range, check on a per-group basis, and consider it a success if at
> least one of the groups is available for the OS to use.
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Peter Tyser <ptyser@xes-inc.com>
> Cc: Aaron Sierra <asierra@xes-inc.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
> That's probably not the nicest code you've seen, but everything else I
> could think of either couldn't work or was looking worse. If anyone can
> think of a better approach, I'm all ears.

I'm not very good at Intel and SMBus so cannot really help either.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I guess you're bringing this through Sam's tree.

Yours,
Linus Walleij
