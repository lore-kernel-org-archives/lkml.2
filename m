Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab2EAAes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:34:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38048 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2EAAep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:34:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5AnsmfQs4oa3P7AQyPTJ+YqCVVh5p2L=bmDY=A+BO9PQ@mail.gmail.com>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
	<1332135781-13695-6-git-send-email-yinghai@kernel.org>
	<CAErSpo5AnsmfQs4oa3P7AQyPTJ+YqCVVh5p2L=bmDY=A+BO9PQ@mail.gmail.com>
Date: Mon, 30 Apr 2012 17:34:45 -0700
X-Google-Sender-Auth: SZloAk8sSxp7d3DjO9bs-ZzHmjw
Message-ID: <CAE9FiQUH1SiToMBanL7brzem920rCoq70hh3KKxH-ps190=51w@mail.gmail.com>
Subject: Re: [PATCH -v11 05/30] PCI: Add busn_res operation functions
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

On Mon, Apr 30, 2012 at 4:29 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sun, Mar 18, 2012 at 11:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> +void pci_bus_update_busn_res_end(struct pci_bus *b, int bus_max)
>> +{
>> +       struct resource *res = &b->busn_res;
>> +       struct resource old_res = *res;
>> +
>> +       res->end = bus_max;
>
> I've mentioned before that I'm not comfortable with updating the
> struct resource after it's been inserted into the tree.  If you want
> to do an in-place update, I think you need to add a new interface in
> kernel/resource.c so it can make sure the resource tree remains
> consistent.

ok, will add one function in kernel/resource.c to make sure that end
could be updated safely
by checking parent and children.
