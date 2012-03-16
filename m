Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161031Ab2CPUmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:42:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52611 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765Ab2CPUmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:42:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7JS6N3XzVm=_A-oFF_VpmuQaAG_KagxAOEzpEPnhRP_g@mail.gmail.com>
References: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
	<1330570837-26638-29-git-send-email-yinghai@kernel.org>
	<CAErSpo7JS6N3XzVm=_A-oFF_VpmuQaAG_KagxAOEzpEPnhRP_g@mail.gmail.com>
Date: Fri, 16 Mar 2012 13:42:16 -0700
X-Google-Sender-Auth: mLePbymjGCD3YL33e6ikTxkGp_4
Message-ID: <CAE9FiQWPCZ-2Xjk2fHZfuQC1fm3WpR9BRbgb9RJCDe_KKEKvZQ@mail.gmail.com>
Subject: Re: [PATCH 28/36] PCI: Add pci_bus_extend/shrink_top()
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 12:36 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> I've objected to this before on the grounds that it's not safe to
> update res->end because res is already linked into the resource tree,
> but I just noticed another problem.
>
> Tree updates are protected by resource_lock, but we don't hold that
> here.  I'm sure you "know" that this update can't race with any other
> conflicting resource operations, but its safety certainly is not
> obvious from the patch.
>
> I think a better implementation would be to add something like
> "resource_extend()" that could live in kernel/resource.c so it could
> do the appropriate locking and checking.  Such an interface could also
> be independent of the resource type, which may be useful when doing
> mem/io resource reassignment.

Thanks for point it out.

Let me thinking about it.

>
> This patch is already in Jesse's linux-next branch (commit
> c901d4c0407), so I'm leaving it up to you and Jesse to figure out
> what, if anything, to do about this.

No, this patch is one in busn_alloc patchset. Jesse did NOT pick that
patchset yet.

Yinghai
