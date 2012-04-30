Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab2D3X0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 19:26:17 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55898 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab2D3X0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 19:26:14 -0400
MIME-Version: 1.0
In-Reply-To: <1332135781-13695-5-git-send-email-yinghai@kernel.org>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org> <1332135781-13695-5-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 30 Apr 2012 17:25:52 -0600
Message-ID: <CAErSpo6Wbjh_pzDOkGRoog2WeJQET9UT0fiaanV0r15pq7hT6Q@mail.gmail.com>
Subject: Re: [PATCH -v11 04/30] PCI: Add busn_res into struct pci_bus.
To: Yinghai Lu <yinghai@kernel.org>
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
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 11:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Will use it to track bus number resource tree.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  include/linux/pci.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index d93d3ae..7c03852 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -419,6 +419,7 @@ struct pci_bus {
>        struct list_head slots;         /* list of slots on this bus */
>        struct resource *resource[PCI_BRIDGE_RESOURCE_NUM];
>        struct list_head resources;     /* address space routed to this bus */
> +       struct resource busn_res;       /* track registered bus num range */
>
>        struct pci_ops  *ops;           /* configuration access functions */
>        void            *sysdata;       /* hook for sys-specific extension */

struct pci_bus already includes "secondary" and "subordinate".    This
new "busn_res" looks like it will contain the same information.  Why
do we need both?
