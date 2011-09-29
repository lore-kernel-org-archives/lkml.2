Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab1I2Nxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:53:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab1I2Nxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:53:31 -0400
MIME-Version: 1.0
In-Reply-To: <1317270796.29415.160.camel@pasglop>
References: <4E82017C.3010304@redhat.com>
	<CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com>
	<4E8215B6.1020108@redhat.com>
	<CAMaF-rPidKH3oZYLMN4QfJaG5m6rnCsCrb+1uTfQHTJyL2cxqg@mail.gmail.com>
	<1317270796.29415.160.camel@pasglop>
Date: Thu, 29 Sep 2011 08:53:26 -0500
Message-ID: <CAMaF-rPPUcSLJfYVv7YNnQbvPPNug9hmO5XQjNKm9+-Prd67MQ@mail.gmail.com>
Subject: Re: [REGRESSION] e1000e failure triggered by "PCI: Remove MRRS
 modification from MPS setting code"
From: Jon Mason <mason@myri.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Avi Kivity <avi@redhat.com>, Sven Schnelle <svens@stackframe.org>,
        Simon Kirby <sim@hostway.ca>, Eric Dumazet <eric.dumazet@gmail.com>,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 11:33 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
>> Booting with "pci=pcie_bus_perf" should provide you with the same
>> behavior as before (e.g., with the patch reverted).  This should
>> enable you work around this issue until I can get it resolved.  On the
>> positive side, your system should be 10% faster than it was in 3.0
>> (due to the PCI bus payloads being 2x larger).
>
> Ugh, that's assuming your fixes for the "perf" mode are in, which I
> thought wasn't the case yet ... without them, "perf" does very wrong
> things..

Yes, but this was "working" before.  The patch he wants reverted was
the one that makes MPS "Safe" the default.  So, changing it to "perf"
would give it the same behavior as before.

>> If you can provide the same output with the patch not reverted, it
>> would be very beneficial.  Based on your description, the lockup only
>> occurs with traffic.  You can gather this before any traffic goes out
>> (perhaps booting without networking enabled).
>
> Right, the output he provided has the MRRS clearly changing in addition
> to the MPS.
>
> Ideally, we'd need the output with current upstream vs. with before your
> very first patch went in and compare that.
>
> Also, Avi, can you send these outputs like patches ? IE without wrapping
> them ? That would be handy :-)
>
> Cheers,
> Ben.
>
>
>
