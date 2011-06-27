Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1F0Req (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 13:34:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55458 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab1F0Rel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 13:34:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eNGdKmUlTVx3SavMXX0FZkB6a6LnYskyuhgKj+mcQ81l9nTk6yVGNBGd1YAKcaPF7n
         R29ToCqq7SNuufrTkmSw==
MIME-Version: 1.0
In-Reply-To: <20110624192903.GM22917@ram-laptop>
References: <1308561849-3223-1-git-send-email-linuxram@us.ibm.com>
 <4DFFB6B0.6090307@hartkopp.net> <4DFFB945.5090203@hartkopp.net>
 <20110620214127.GA22917@ram-laptop> <4DFFC2FC.5050502@hartkopp.net>
 <4E0353CA.7000708@hartkopp.net> <20110624192903.GM22917@ram-laptop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 27 Jun 2011 11:34:17 -0600
Message-ID: <BANLkTikG0oTdSSh9oLc-M_zzFWuTu0sh_w@mail.gmail.com>
Subject: Re: [PATCH 0/4] PCI: fix cardbus and sriov regressions
To: Ram Pai <linuxram@us.ibm.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>, yinghai@kernel.org,
        jbarnes@virtuousgeek.org, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+linux-pci again]

On Fri, Jun 24, 2011 at 1:29 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> On Thu, Jun 23, 2011 at 04:55:06PM +0200, Oliver Hartkopp wrote:
>> Hello RP,
>>
>> unfortunately i noticed the discussion on linux-kernel ML a bit late, as i did
>> not subscribe it due to the traffic.
>
> sorry, did not see this mail earlier.
>
>
>> >>> When comparing the logs with mgdiff, i found
>> >>>
>> >>> in revered:
>> >>>
>> >>> pci_bus 0000:04: resource 0 [io  0x2000-0x20ff]
>> >>> pci_bus 0000:04: resource 1 [io  0x2400-0x24ff]
>> >>>
>> >>> in the fixed version (4 patches)
>> >>>
>> >>> pci_bus 0000:04: resource 0 [io  0x2400-0x24ff]
>> >>> pci_bus 0000:04: resource 1 [io  0x2001-0x2100]
>>
>> Did you get further with the unusual alignment?
>
> No. i was thinking this alignment  should be ok, since that cardbus resource
> has to be SIZE aligned and not START aligned.
>
> However if it is not acceptable, i will figure out a way
> to get it aligned on the right boundaries.

Does the bridge leading to bus 04 really support a window starting at 0x2001?

I assume this is a CardBus bridge because it has two I/O windows.  My
interpretation of the MindShare CardBus book (I don't have the PC Card
Standard) is that the low two bits of the I/O base address register
tell you whether 16- or 32-bit addressing is supported (00b means
16-bit decoding is used, 01b means 32-bit decoding is used), and that
the actual window starts on a four-byte aligned address.

If that's correct, an I/O base register containing 0x2001 would mean a
window starting at 0x2000 and supporting 32-bit decoding, and it would
be impossible to have a window starting at 0x2001, i.e., one that
contains 0x2001 but not 0x2000.

Bjorn
