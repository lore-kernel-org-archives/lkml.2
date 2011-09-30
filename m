Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1I3HD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:03:28 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:44649 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab1I3HDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 03:03:25 -0400
Message-ID: <fc03678ef8baaa29a8ab3c086ba6bb78.squirrel@webmail.sf-mail.de>
In-Reply-To: <20110930001633.GA11436@myri.com>
References: <4E82017C.3010304@redhat.com>
    <CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com>
    <4E8215B6.1020108@redhat.com> <20110930001633.GA11436@myri.com>
Date: Fri, 30 Sep 2011 09:03:24 +0200
Subject: Re: Workaround for Intel MPS errata
From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
To: "Jon Mason" <mason@myri.com>
Cc: "Avi Kivity" <avi@redhat.com>, "Sven Schnelle" <svens@stackframe.org>,
        "Simon Kirby" <sim@hostway.ca>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Niels Ole Salscheider" <niels_ole@salscheider-online.de>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Ben Hutchings" <bhutchings@solarflare.com>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hey Avi,
> Can you try this patch?  It should resolve the issue you are seeing.
>
> Thanks,
> Jon
>
>     PCI: Workaround for Intel MPS errata
>
>     Intel 5000 and 5100 series memory controllers have a known issue if
> read
>     completion coalescing is enabled (the default setting) and the PCI-E
>     Maximum Payload Size is set to 256B.  To work around this issue,
> disable
>     read completion coalescing if the MPS is 256B.
>
>     http://www.intel.com/content/dam/doc/specification-update/5000-chipset-memory-controller-hub-specification-update.pdf
>     http://www.intel.com/content/dam/doc/specification-update/5100-memory-controller-hub-chipset-specification-update.pdf
>
>     Reported-by: Avi Kivity <avi@redhat.com>
>     Signed-off-by: Jon Mason <mason@myri.com>
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index a919db2..13c733a 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1361,6 +1361,80 @@ static int pcie_find_smpss(struct pci_dev *dev,
> void *data)
>  	return 0;
>  }
>
> +static void pcie_errata_check(int mps)
> +{

While this whole function is about Intel 5x00 devices the name of it is
very generic (and in a very generic file). Maybe this can be changed, e.g.
"fixup:" renamed to "fixup_intel_5x00:". Also I wonder if that shouldn't
be a nop when CONFIG_PCI_QUIRKS is not set.

Eike
