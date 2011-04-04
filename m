Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1DDPZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:25:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:43421 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab1DDPZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:25:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=PuqyXE9y1KrSx39PL98TyGgQ5nued2XK1FJuFsEcJ7JqDke/PMOO+TSzS98GrcjSqH
         xQqEzS80Chqi5ewzTM5Q==
MIME-Version: 1.0
In-Reply-To: <1301902664.2549.76.camel@pasglop>
References: <1301882694.2549.53.camel@pasglop> <1301887630.2549.71.camel@pasglop>
 <1301902664.2549.76.camel@pasglop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 4 Apr 2011 09:25:20 -0600
Message-ID: <BANLkTimBD=NfFKGpy0ZTnT9Dcu=dkTHxZg@mail.gmail.com>
Subject: Re: [RFC/PATCH] of: Match PCI devices to OF nodes generically
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-arch@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 1:37 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:

> powerpc has two different ways of matching PCI devices to their
> corresponding OF node (if any) for historical reasons. The ppc64 one
> does a scan looking for matching bus/dev/fn, while the ppc32 one does a
> scan looking only for matching dev/fn on each level in order to be
> agnostic to busses being renumbered (which Linux does on some
> platforms).
>
> This removes both and instead moves the matching code to the PCI core
> itself. It's the most logical place to do it: when a pci_dev is created,
> we know the parent and thus can do a single level scan for the matching
> device_node (if any).

Some of this is reminiscent of the ACPI/PCI binding we do on x86/ia64,
e.g., acpi_get_pci_dev() and the stuff in drivers/acpi/glue.c.  Have
you looked at that to see if there's any hope of covering both OF and
ACPI with something more generic?

Bjorn
