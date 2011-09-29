Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab1I2EeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 00:34:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:53566 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab1I2EeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 00:34:03 -0400
Subject: Re: [REGRESSION] e1000e failure triggered by "PCI: Remove MRRS
 modification from MPS setting code"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jon Mason <mason@myri.com>
Cc: Avi Kivity <avi@redhat.com>, Sven Schnelle <svens@stackframe.org>,
        Simon Kirby <sim@hostway.ca>, Eric Dumazet <eric.dumazet@gmail.com>,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <CAMaF-rPidKH3oZYLMN4QfJaG5m6rnCsCrb+1uTfQHTJyL2cxqg@mail.gmail.com>
References: <4E82017C.3010304@redhat.com>
	 <CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com>
	 <4E8215B6.1020108@redhat.com>
	 <CAMaF-rPidKH3oZYLMN4QfJaG5m6rnCsCrb+1uTfQHTJyL2cxqg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Sep 2011 14:33:16 +1000
Message-ID: <1317270796.29415.160.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Booting with "pci=pcie_bus_perf" should provide you with the same
> behavior as before (e.g., with the patch reverted).  This should
> enable you work around this issue until I can get it resolved.  On the
> positive side, your system should be 10% faster than it was in 3.0
> (due to the PCI bus payloads being 2x larger).

Ugh, that's assuming your fixes for the "perf" mode are in, which I
thought wasn't the case yet ... without them, "perf" does very wrong
things..

> If you can provide the same output with the patch not reverted, it
> would be very beneficial.  Based on your description, the lockup only
> occurs with traffic.  You can gather this before any traffic goes out
> (perhaps booting without networking enabled).

Right, the output he provided has the MRRS clearly changing in addition
to the MPS.

Ideally, we'd need the output with current upstream vs. with before your
very first patch went in and compare that.

Also, Avi, can you send these outputs like patches ? IE without wrapping
them ? That would be handy :-)

Cheers,
Ben.


