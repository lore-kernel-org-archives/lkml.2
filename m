Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2GIWiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:38:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48279 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2GIWiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:38:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXXXg=ChD8h2+ot2igtYR7N_C5FHO5ziHZwwL_7BVPBmQ@mail.gmail.com>
References: <1341861422-25861-1-git-send-email-geert@linux-m68k.org>
 <CAErSpo47VO7F=fY1CRS-uwvp4CsTNttk2tasszs5Fdo7j7RqMA@mail.gmail.com> <CAMuHMdXXXg=ChD8h2+ot2igtYR7N_C5FHO5ziHZwwL_7BVPBmQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 9 Jul 2012 16:37:46 -0600
Message-ID: <CAErSpo7HeiiswFVdN6DDgCqYf4M=Qg4gUsAfnBkA8HFQG=0bwQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.5-rc6
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 3:31 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Hi Bjorn (or Björn?),
>
> On Mon, Jul 9, 2012 at 11:20 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> There are some PCI-related regressions here that I'd like to fix, but
>> I don't know where to start.  For example, these:
>>
>>>   + drivers/pci/quirks.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 3154:2
>>>   + drivers/pci/quirks.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 3144:2
>>
>> I don't see these in an x86 build, so I assume these are from some
>> other arch or other config.  Can I tell which one?
>
> xtensa-allmodconfig
>
> http://kisskb.ellerman.id.au/kisskb/buildresult/6668885/

Thanks!

There are a ton of xtensa warnings related to the fact that xtensa
doesn't support the iomap interface (ioread, iowrite, pci_iomap,
pci_iounmap, etc).

I'm going to punt and hope Chris takes care of this.

Bjorn
