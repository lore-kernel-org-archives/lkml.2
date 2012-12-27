Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2L0Bd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 20:33:29 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:61944 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab2L0Bd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 20:33:27 -0500
MIME-Version: 1.0
In-Reply-To: <20121205163019.GC28556@liondog.tnic>
References: <20121204210305.4515.91100.stgit@grignak.americas.hpqcorp.net>
 <20121204210312.4515.13415.stgit@grignak.americas.hpqcorp.net>
 <20121205143202.GD2364@liondog.tnic> <A961433CDFF2F640A2866803152E61F9516F279F@G4W3219.americas.hpqcorp.net>
 <20121205163019.GC28556@liondog.tnic>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 26 Dec 2012 18:33:04 -0700
Message-ID: <CAErSpo4j5k6uQJHV1sMdOqosVNVygehfXB+y7bB7uH14B6vG8w@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] aerdrv: Enhanced AER logging
To: Borislav Petkov <bp@alien8.de>, "Ortiz, Lance E" <lance.oritz@hp.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 9:30 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Dec 05, 2012 at 04:14:14PM +0000, Ortiz, Lance E wrote:
>> I removed the prefix argument because it was never used by its caller
>> and never set. The reason I added the prefix variable and set it to
>> NULL was to help in breaking up the patch and adding it would help the
>> intermittent patch build without changing too much code. I knew I was
>> actually going to use the variable in patch 3.
>
> No, the correct way to do that is to keep all changes that belong
> logically together in a single patch for ease of reviewing and avoid
> breakages. And in your case this should be pretty easy: simply move all
> the 'prefix' touching code to patch #3 and you're done, AFAICT.

Lance, you didn't add all the "prefix" stuff in AER, but since you're
touching it, I think things will make more sense if you clean it up at
the same time.  There are a lot of printk() calls there that should be
converted to dev_printk().

I think I see why it was done that way -- it sticks either
KERN_WARNING or KERN_ERR at the beginning of the prefix, then uses
plain printk() later.  I guess that means you only have to pass around
the prefix argument, rather than both a "level" and a "struct pci_dev
*".  But I think it will be simpler overall to pass both and take
advantage of dev_printk() and stop emulating it.

Bjorn
