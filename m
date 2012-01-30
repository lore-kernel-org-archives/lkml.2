Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab2A3SmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:42:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35746 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2A3SmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:42:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo6dihCWme3bgVV0AjHXnKd78BskLVj2LZqHocoAp83h+Q@mail.gmail.com>
References: <1327718971-9598-1-git-send-email-yinghai@kernel.org>
	<1327718971-9598-9-git-send-email-yinghai@kernel.org>
	<CAErSpo6dihCWme3bgVV0AjHXnKd78BskLVj2LZqHocoAp83h+Q@mail.gmail.com>
Date: Mon, 30 Jan 2012 10:42:01 -0800
X-Google-Sender-Auth: omJIHSd69pekYrZMbHmaWuqDXLE
Message-ID: <CAE9FiQX1=U=ysmvRY4Kwx8MAR1KWxn3JaD32xjdCSnbWXT7V2A@mail.gmail.com>
Subject: Re: [PATCH 08/13] PCI: Add pci_bus_extend/shrink_top()
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 7:50 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Jan 27, 2012 at 6:49 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> extend or shrink bus and parent buses top (subordinate)
>>
>> extended range is verified safe range, and stop at recorded parent_res.
...
> This makes me nervous for the same reason as
> pci_bus_update_busn_res_end() -- we're changing res->end for resources
> already in a tree.  How do we know the tree remains consistent?
>

Yes, we already try to allocate near the top and later pad the top. So
it is safe to just adjust top.

Yinghai
