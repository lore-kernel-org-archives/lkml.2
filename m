Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab2EAT2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:28:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34232 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641Ab2EAT21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:28:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5EdBY-8M5FnQaGHOAvhaGO7qLHdDkmYGyDRN9de4umNw@mail.gmail.com>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
	<1332135781-13695-5-git-send-email-yinghai@kernel.org>
	<CAErSpo6Wbjh_pzDOkGRoog2WeJQET9UT0fiaanV0r15pq7hT6Q@mail.gmail.com>
	<CAE9FiQV0XTd_1Ujz=tb6BSuwJvJ9nbT_GbE2PREtgMGv=yG0+g@mail.gmail.com>
	<CAErSpo57pH81KtUbYZ3j6y4kC+ka33Lzr4rfcywVWf8OTmH_5Q@mail.gmail.com>
	<CAE9FiQUOsMOQgZXCuPHpc6ZSEGnY3nv+uy1o0xvrW8-LKwNZrg@mail.gmail.com>
	<CAErSpo5EdBY-8M5FnQaGHOAvhaGO7qLHdDkmYGyDRN9de4umNw@mail.gmail.com>
Date: Tue, 1 May 2012 12:28:26 -0700
X-Google-Sender-Auth: uJIJpIoLfa-jHettzSRm2qoLRns
Message-ID: <CAE9FiQVgDQO0ZUbYr_KC2byM6J+Y_RUT=Xpcf-Atay7_tgOFTg@mail.gmail.com>
Subject: Re: [PATCH -v11 04/30] PCI: Add busn_res into struct pci_bus.
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 8:40 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> bridge's Subordinate Bus Number in config space == bus->subordinate ==
>>> bus->busn_res.end (correct me if I'm wrong).  I don't like the
>>> redundancy in this case.
>>
>> there are about 70 bus->subordinate reference and 40 bus->secondary reference.
>>
>> could try to update them in following patch set.
>
> If you're proposing this:
>  1. add bus->busn_res
>  2. remove bus->subordinate and bus->secondary
> I fully support that, and I'd like to merge both pieces at the same
> time (different patches is fine; I just want to make sure both pieces
> actually happen).

yes. Can you consider applying  "removing bus->subordinate" patch set
to be applied after:
for-pci-busn-alloc
for-pci-root-bus-hotplug
for-pci-for-each-res-addon
for-pci-res-alloc

otherwise there would be some extra rebase work for last three patch set.

Yinghai
