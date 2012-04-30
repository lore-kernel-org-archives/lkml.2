Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab2D3W7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:59:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43816 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab2D3W73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:59:29 -0400
MIME-Version: 1.0
In-Reply-To: <1332135624-13528-1-git-send-email-yinghai@kernel.org>
References: <1332135624-13528-1-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 30 Apr 2012 16:59:07 -0600
Message-ID: <CAErSpo4sYW9juTsJbuow7OzQH3Q-7tuQT1OdnVvGD-b5Gtfb1Q@mail.gmail.com>
Subject: Re: [PATCH -v3 00/11] PCI: pci_host_bridge related cleanup
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 11:40 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> will add struct device dev into host_bridge struct.
> also will add release support to make sure allocated resource get
> freed during root bus removal including hostbridge and pci_sysdata.
>
> The patches need to apply to linus v3.3 plus pci/linux-next
>
> could get from
>        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-hostbridge-cleanup

I applied the patches from this branch to my "next" branch, with the
exception of the following.  Please take a look and make sure my
"next" branch has what you expect.

>  x86, PCI: Merge root info printing for not using _CRS path

This changes from printing info for all HT links to just one (probably
unintentional).  It should also use the "[bus %02x-%02x]" format as we
do elsewhere.

> x86, PCI: Add print all root info for not using _CRS path

This fixes the unintentional "only print one HT link info" change from above.

> x86, PCI: Allocate temp range array in amd_bus pci_root_info probing

This had no changelog, so I don't know why we want this.

Bjorn
