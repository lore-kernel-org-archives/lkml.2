Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab0LPWMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 17:12:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819Ab0LPWMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 17:12:21 -0500
MIME-Version: 1.0
In-Reply-To: <20101216173846.8185.82045.stgit@bob.kio>
References: <20101216173614.8185.19462.stgit@bob.kio> <20101216173846.8185.82045.stgit@bob.kio>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Dec 2010 14:03:21 -0800
Message-ID: <AANLkTindCiEeHDhDJhc9o-iZHvts2d1QnH2CxmDtgb6=@mail.gmail.com>
Subject: Re: [PATCH 6/9] resources: add arch hook for preventing allocation in
 reserved areas
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Adam Belay <abelay@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 9:38 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
> This adds arch_remove_reservations(), which an arch can implement if it
> needs to protect part of the address space from allocation.

Oh, I just realized - we've had gcc (or maybe "as") bugs when the weak
symbol is in the same compilation unit as the caller, and some part of
the toolchain just ends up short-circuiting it (either gcc inlines it,
or maybe it was that as resolves it early). Making the "weak" part not
work, because it binds strongly.

It may be that we don't support those gcc versions any more, but I
thought I'd bring the issue up. It's safer to put the weak functions
in some other file if possible.

                              Linus
