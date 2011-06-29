Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab1F2VYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:24:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52185 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1F2VYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:24:43 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=2ZMmrwMrnyEyEZAEsCUQNnd5n1j8J0xzSEF=ahrJmLw@mail.gmail.com>
References: <fa.fHPNPTsllvyE/7DxrKwiwgVbVww@ifi.uio.no>
	<532cc290-4b9c-4eb2-91d4-aa66c01bb3a0@glegroupsg2000goo.googlegroups.com>
	<BANLkTik3mEJGXLrf_XtssfdRypm3NxBKvkhcnUpK=YXV6ux=Ag@mail.gmail.com>
	<20110629080827.GA975@phantom.vanrein.org>
	<BANLkTikw9bnrurUo8n-6yUwwQ0zOv5iAOBDt=T6Nm6nkUd7vLA@mail.gmail.com>
	<BANLkTi=2ZMmrwMrnyEyEZAEsCUQNnd5n1j8J0xzSEF=ahrJmLw@mail.gmail.com>
Date: Wed, 29 Jun 2011 14:24:41 -0700
X-Google-Sender-Auth: 7zJLqAvrzV3j-Jv4nSjGZ8w26Go
Message-ID: <BANLkTinN0EOH=OMQ8idG7Xt5OufU-6Rn3A@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
From: Tony Luck <tony.luck@intel.com>
To: Craig Bergstrom <craigb@google.com>
Cc: linux-kernel@vger.kernel.org, fa.linux.kernel@googlegroups.com,
        Rick van Rein <rick@vanrein.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stefan Assmann <sassmann@kpanic.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        Nancy Yuen <yuenn@google.com>, Michael Ditto <mditto@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One extra consideration for this whole proposal ...

Is the "physical address" a stable enough representation of the location
of the faulty memory cells?

On high end systems I can see a number of ways where the mapping
from cells to physical address may change across reboot:

1) System support redundant memory (rank sparing or mirroring)
2) BIOS self test removes some memory from use
3) A multi-node system elects a different node to be boot-meister,
which results in reshuffling of the address map.

If any of these can happen: then it doesn't matter whether we have
a list of addresses, or a pattern that expands to a list of addresses.
We'll still mark some innocent memory as bad, and allow some known
bad memory to be used - because our "addresses" no longer correspond
to the bad memory cells.

-Tony
