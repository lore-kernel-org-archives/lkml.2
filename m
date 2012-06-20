Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab2FTR7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:59:46 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59332 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2FTR7o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:59:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4x8+M6hGAqJR2rjGEGk2AnnZfJkmaJrJedzhnKiRf2qw@mail.gmail.com>
References: <CAOPLpQfUm-2ENkbnYfXEn1nf9FHnaRk3aqQTSTBWb-CsfCUCFA@mail.gmail.com>
 <CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com>
 <CAErSpo57H_ZD_-Z8z9vD3c50My4Rejtc9gXXrxGxDtQomYmrSA@mail.gmail.com>
 <CAOPLpQeJTfB2UNy3O9FgRCyZb=LyMqd0SOsz7qDM0Ur_sfeNhg@mail.gmail.com>
 <CAE9FiQVzKr+nyBh=8-v+HEDF=7JqN2CqdTNx1=LHTq=c_OyZvg@mail.gmail.com>
 <CAErSpo40SDii6PTNisAnsn6SoB7SzPUGztWAg9vaZZv+ByQsPw@mail.gmail.com>
 <CAE9FiQVDnS9n28GQrKVVTU7GiMtJZLFN1T9vmOm5oSysvMEVhQ@mail.gmail.com> <CAErSpo4x8+M6hGAqJR2rjGEGk2AnnZfJkmaJrJedzhnKiRf2qw@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Wed, 20 Jun 2012 13:59:23 -0400
Message-ID: <CAOPLpQchY4gMYaw-Ew5uujD9JCu==VLjQ7Z_OjrT6akTgX4+iA@mail.gmail.com>
Subject: Re: SNB PCI root information
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 1:17 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> I don't understand this.  Is there an *advantage* to silently throwing
> away the information the user specified on the command line?  If the
> user goes to the trouble of discovering and using a command line
> argument, I think that user-supplied information should override
> anything the kernel can figure out on its own.  Ulrich, do you have an
> opinion either way?

If the BIOS information we look for would be something generic then we
might want to have something to overwrite.  But in this case it's a
very specific piece of information which only has one correct value
and I'd hope the BIOS writers get it right.

Assuming this there *might* be value in having it the way the patch
does now.  If the BIOS changes it could in theory also renumber the
devices etc.  In this case the kernel command line overwrite values
might become wrong while a newly-added _PXM entry might be right.
We've seen all kind of things happening on BIOS updates...

On the other hand it's easy enough to then remove the kernel command
line parameter.  It's also probably more in line with other parameters
which overwrite information the kernel determines otherwise
automatically.

I'd be willing to go with Yinghai's recommendation and give the BIOS
writers the benefit of a doubt that they get things right.  If they
prove to be incapable again we can still change the option handling to
overwrite the kernel setting regardless.
