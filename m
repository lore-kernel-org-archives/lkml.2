Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab2GZV5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:57:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35884 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751489Ab2GZV5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:57:35 -0400
Message-ID: <1343339854.17538.50.camel@joe2Laptop>
Subject: Re: [PATCH v3 1/4] ACPI: Add acpi_pr_<level>() interfaces
From: Joe Perches <joe@perches.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Toshi Kani <toshi.kani@hp.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com
Date: Thu, 26 Jul 2012 14:57:34 -0700
In-Reply-To: <CAErSpo4cPuFLmp=b2JUUP-nDdtsFmJFda0az-9z9fEnys23L6w@mail.gmail.com>
References: <1343257978-7085-1-git-send-email-toshi.kani@hp.com>
	 <1343257978-7085-2-git-send-email-toshi.kani@hp.com>
	 <CAErSpo4=HDaWTusKf+tRU6aXmj-mC1i7CswnDzDLZii21i9NaQ@mail.gmail.com>
	 <1343336330.3010.496.camel@misato.fc.hp.com>
	 <20120726213730.GA2149@google.com> <1343338982.17538.45.camel@joe2Laptop>
	 <CAErSpo4cPuFLmp=b2JUUP-nDdtsFmJFda0az-9z9fEnys23L6w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 15:50 -0600, Bjorn Helgaas wrote:
> On Thu, Jul 26, 2012 at 3:43 PM, Joe Perches <joe@perches.com> wrote:
> > On Thu, 2012-07-26 at 15:37 -0600, Bjorn Helgaas wrote:
> >>     PNP0C01:00: new device for \_SB_.PCI0.ISA_.MBIO
> >>
> >> I fiddled with this a while ago; it would look something like this:
> > []
> >> +static noinline_for_stack
> >> +char *acpi_name_string(char *buf, char *end, acpi_handle handle,
> >> +                    struct printf_spec spec, const char *fmt)
[]
> Yes.  I'm hesitant about this approach in general, because I don't
> think printing the ACPI path is something we should be doing often.
> It's not like a struct resource or a MAC address, where there are
> dozens or hundreds of users.  I really think we should only print ACPI
> paths in one or two places, so adding a %p extension would waste a
> letter and encourage the wrong behavior.

I don't much care for adding ACPI specific calls to vsprintf
as acpi is supposed to be OS generic anyway.

I don't think there's anything wrong with Toshi's approach.
Anyone that looks for speed in a logging message is looking
for an oddly fitting thing.  Tracing sure, but logging?

I also don't see anything wrong with renaming it to just
acpi_<level>, but that's a different discussion.

cheers, Joe

