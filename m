Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab2ALDit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 22:38:49 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37518 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab2ALDir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 22:38:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120111103408.30cfa338@jbarnes-desktop>
References: <20120111103408.30cfa338@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jan 2012 19:38:25 -0800
X-Google-Sender-Auth: -QM5yRlo2ZnmHeznCKJKoc0n2h8
Message-ID: <CA+55aFwDVEH1NwEgKCQSv9ee3P2ma1aqtjOo-s2BeURyeTGo8g@mail.gmail.com>
Subject: Re: [git pull] PCI changes
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Garrett <mjg@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 10:34 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Matthew Garrett (1):
>      PCI: Rework ASPM disable code

Yay.

However, looking this through some more, I'm still a bit confused by
the pcie_clear_aspm() call in acpi_pci_root_add().

It seems to be explicitly against the rules elsewhere - we clear ASPM
even though ACPI_FADT_NO_ASPM is set - which the changelog (and the
other parts of that commit) says means "don't touch pre-existing ASPM
state").

So why is acpi_pci_root_add() special? Cna you explain that part to me?

                    Linus
