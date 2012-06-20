Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab2FTRSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:18:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50135 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab2FTRSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:18:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVDnS9n28GQrKVVTU7GiMtJZLFN1T9vmOm5oSysvMEVhQ@mail.gmail.com>
References: <CAOPLpQfUm-2ENkbnYfXEn1nf9FHnaRk3aqQTSTBWb-CsfCUCFA@mail.gmail.com>
 <CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com>
 <CAErSpo57H_ZD_-Z8z9vD3c50My4Rejtc9gXXrxGxDtQomYmrSA@mail.gmail.com>
 <CAOPLpQeJTfB2UNy3O9FgRCyZb=LyMqd0SOsz7qDM0Ur_sfeNhg@mail.gmail.com>
 <CAE9FiQVzKr+nyBh=8-v+HEDF=7JqN2CqdTNx1=LHTq=c_OyZvg@mail.gmail.com>
 <CAErSpo40SDii6PTNisAnsn6SoB7SzPUGztWAg9vaZZv+ByQsPw@mail.gmail.com> <CAE9FiQVDnS9n28GQrKVVTU7GiMtJZLFN1T9vmOm5oSysvMEVhQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 20 Jun 2012 11:17:52 -0600
Message-ID: <CAErSpo4x8+M6hGAqJR2rjGEGk2AnnZfJkmaJrJedzhnKiRf2qw@mail.gmail.com>
Subject: Re: SNB PCI root information
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ulrich Drepper <drepper@gmail.com>, jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 12:20 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Jun 19, 2012 at 5:36 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>> I'm not opposed to something like this, if people think it's useful.
>>
>> This patch sets the node quite early, before we even look at the _PXM
>> information in pci_acpi_scan_root().  That means if the BIOS does
>> supply a _PXM method and the user gives this argument, the
>> user-supplied info is silently overwritten.  To me it would make more
>> sense to handle an option like this *after* we look for _PXM info.
>> That way it could be used to compensate for both missing and incorrect
>> _PXM info.
>
> yes, we can only let user input and hostbridge touch that array.
>
> but i'd like to only handle missing _PXM case.
>
> If the BIOS provide wrong _PXM, that BIOS really should be fixed at first.

I don't understand this.  Is there an *advantage* to silently throwing
away the information the user specified on the command line?  If the
user goes to the trouble of discovering and using a command line
argument, I think that user-supplied information should override
anything the kernel can figure out on its own.  Ulrich, do you have an
opinion either way?
