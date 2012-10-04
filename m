Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab2JDUsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:48:30 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:37907 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab2JDUsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:48:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVyx5EL8RCuHF5rOoT5Zj7ksnAFJgg09hGE_sHfRJJXpw@mail.gmail.com>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
 <1349305214-3241-1-git-send-email-yinghai@kernel.org> <20121004174746.GA24119@google.com>
 <CAE9FiQWDnrk7VccFLLHucCVSxN5RRS0-8pwYazLy2aw3oqmPLQ@mail.gmail.com>
 <CAErSpo48XLzLvziACEi+0nWuRXurHCLnw+iwgqu8-BRutjNtWw@mail.gmail.com> <CAE9FiQVyx5EL8RCuHF5rOoT5Zj7ksnAFJgg09hGE_sHfRJJXpw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 4 Oct 2012 14:47:56 -0600
Message-ID: <CAErSpo5tWXS5xmstNhSVzxZfL8LCZ7tPjetADV6vLwQeBbcqLw@mail.gmail.com>
Subject: Re: [PATCH 0/4] ACPI: kill acpi_pci_root_start
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 2:14 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Oct 4, 2012 at 12:44 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>> To answer your specific question, yes, I do think drivers that are
>> statically built in probably should be registered before devices are
>> enumerated.  That way, the boot-time case is more similar to the
>> hot-add case.
>>
>> Obviously, for drivers that can be modules, the reverse must work as
>> well (enumerate devices, then load and register the driver).  And then
>> the other order (register driver, then enumerate device) must also
>> work so future hot-adds of the same device type work.
>
> so you will have to handle two paths instead one.

I'm not proposing any additional requirements; I'm just describing the
way Linux driver modules work.  Any module *already* must support both
orders (enumerate devices then register driver, as well as register
driver then enumerate and bind to a hot-added device).  And this
should not be two paths, it should be one and the same path for both
orders.

> current booting path sequence are tested more than hot add path.

True.  You're proposing fiddling with driver binding order so we can
use the current boot path ordering at hot-add time.  I'm suggesting
that the "register driver then enumerate device" order is something we
have to support for hot-add anyway, and that we should use the same
ordering at boot-time.  That's more change for the boot-time path, but
I think it's cleaner and more maintainable in the long term.
