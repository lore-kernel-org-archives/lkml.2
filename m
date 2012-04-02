Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab2DBQqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:46:44 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55897 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2DBQqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:46:43 -0400
MIME-Version: 1.0
In-Reply-To: <1332775433.22830.7.camel@ayu>
References: <CA+55aFyR2TXcKdzXontH8B4Reu40bdY_APhuUJeUxm6D-OuQkg@mail.gmail.com>
 <87r4wpx7lr.fsf@silenus.orebokech.com> <1332775433.22830.7.camel@ayu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Apr 2012 09:46:21 -0700
X-Google-Sender-Auth: V9auLxqU-clkN6TgIT6g9WI_sF8
Message-ID: <CA+55aFy_=-8LsSKiDhnVbOamiHJ3R2E5-USiHS4izQTbvCXCrA@mail.gmail.com>
Subject: Re: Linux 3.3 release
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: Romain Francoise <romain@orebokech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 8:23 AM, Calvin Walton <calvin.walton@kepstin.ca> wrote:
> On Mon, 2012-03-19 at 10:28 +0100, Romain Francoise wrote:
>> There seems to be a regression in the final release compared to -rc7,
>> specifically this commit:
>>
>> > Matthew Garrett (1):
>> >       PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
>>
>> causes an early kernel panic on my machine (Intel DP67BG). Reverting the
>> change fixes it. Unfortunately it crashes before setting up the video mode
>> so I don't have the full stack trace, but RIP points to
>> pcie_aspm_init_link_state().
>>
>> When the machine boots successfully, dmesg contains the following related
>> to ASPM:
>>
>> [    0.382384] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
>> [    0.433016] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
>
> This commit is also breaking boot on one of my boxes; it's causing the
> pata_jmicron driver to fail to detect my IDE boot drive. This was
> reported in this thread as well:
> https://lkml.org/lkml/2012/3/22/6
>
> Apparently, using the 'pcie_aspm=force' may work around the issue, from
> some reports that I've seen when searching around. Haven't tried it
> myself, yet.

(Coming back to this thread late)

This issue should be fixed by commit c9651e70ad0a ("ASPM: Fix pcie
devices with non-pcie children") in mainline, and it's in the stable
queue too.

                      Linus
