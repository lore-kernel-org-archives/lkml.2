Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab1HXVu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:50:57 -0400
Received: from mail-yi0-f70.google.com ([209.85.218.70]:40999 "EHLO
	mail-yi0-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1HXVu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:50:56 -0400
X-Greylist: delayed 1646 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Aug 2011 17:50:56 EDT
MIME-Version: 1.0
In-Reply-To: <CAOtrxKMgdSWXRacAy8AVp8q1Zst2NKhvwbUDrhp1pMN5fme9ew@mail.gmail.com>
References: <20110819175316.GA999@ime.usp.br> <CAOtrxKNVckzkxM=ahV13kV=7-Jtj=WWkx_So4pCdVX3e8mdjPw@mail.gmail.com>
 <CA+55aFyyJNnL54o=xRH7CubFLDaQwcF31sqd7tfBcfR8XfnX5g@mail.gmail.com>
 <CAOtrxKN3sugEcNPb0MkihAJ6P+idAUfGnJBoBq_kwxsDiHdR+A@mail.gmail.com> <CAOtrxKMgdSWXRacAy8AVp8q1Zst2NKhvwbUDrhp1pMN5fme9ew@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 24 Aug 2011 15:23:06 -0600
Message-ID: <CAErSpo79Wu7fvm=bCpSN=ydfb9u64r=_WVoV3qBmjqb76CKjXg@mail.gmail.com>
Subject: Re: [Bug 41622] [REGRESSION][BISECTED] Notebook crashes upon
 detecting the PCI subsystem with kernels >= 2.6.24-rc7
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Thomas Meyer <thomas@m3y3r.de>, Gary Hade <garyhade@us.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        bugme-daemon@bugzilla.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If there is anything else that you would like me to change or to
> provide any extra information, then please let me know and I will do
> my best.

I'd still like to see a dmesg log with no arguments (remove the
"acpi=off pnpbios=off noapic nolapic" arguments).  Your machine is new
enough that we'll use PCI _CRS by default, and I'd like to make sure
we're doing the right thing.

I assume that with no arguments, you still need the "skip transparent
bridge sizing" change to boot.

I don't really like that change because in __pci_bus_size_bridges(),
it's not obvious why sizing transparent bridges should be a problem.
If growing transparent bridge windows makes us run out of space, let's
put the smarts ("this bridge is transparent, we can take advantage of
subtractive decode so we may not need to grow the positive decode
windows") at the point where we grow, not at the point where we size.
If we do have enough space, growing the positive decode windows is
better because they're faster than subtractive decode.

Bjorn
