Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab2FSSUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:20:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41787 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2FSSUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:20:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo40SDii6PTNisAnsn6SoB7SzPUGztWAg9vaZZv+ByQsPw@mail.gmail.com>
References: <CAOPLpQfUm-2ENkbnYfXEn1nf9FHnaRk3aqQTSTBWb-CsfCUCFA@mail.gmail.com>
	<CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com>
	<CAErSpo57H_ZD_-Z8z9vD3c50My4Rejtc9gXXrxGxDtQomYmrSA@mail.gmail.com>
	<CAOPLpQeJTfB2UNy3O9FgRCyZb=LyMqd0SOsz7qDM0Ur_sfeNhg@mail.gmail.com>
	<CAE9FiQVzKr+nyBh=8-v+HEDF=7JqN2CqdTNx1=LHTq=c_OyZvg@mail.gmail.com>
	<CAErSpo40SDii6PTNisAnsn6SoB7SzPUGztWAg9vaZZv+ByQsPw@mail.gmail.com>
Date: Tue, 19 Jun 2012 11:20:10 -0700
X-Google-Sender-Auth: TurrBXwr0ZdSUgxGdDaMowEqH8Q
Message-ID: <CAE9FiQVDnS9n28GQrKVVTU7GiMtJZLFN1T9vmOm5oSysvMEVhQ@mail.gmail.com>
Subject: Re: SNB PCI root information
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ulrich Drepper <drepper@gmail.com>, jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 5:36 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> I'm not opposed to something like this, if people think it's useful.
>
> This patch sets the node quite early, before we even look at the _PXM
> information in pci_acpi_scan_root().  That means if the BIOS does
> supply a _PXM method and the user gives this argument, the
> user-supplied info is silently overwritten.  To me it would make more
> sense to handle an option like this *after* we look for _PXM info.
> That way it could be used to compensate for both missing and incorrect
> _PXM info.

yes, we can only let user input and hostbridge touch that array.

but i'd like to only handle missing _PXM case.

If the BIOS provide wrong _PXM, that BIOS really should be fixed at first.

Yinghai
