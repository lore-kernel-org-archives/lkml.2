Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab1KOWeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:34:04 -0500
Received: from mail.vyatta.com ([76.74.103.46]:59099 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484Ab1KOWeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:34:02 -0500
Date: Tue, 15 Nov 2011 14:33:59 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Decotigny <david.decotigny@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>
Subject: Re: [PATCH net-next v4 4/8] forcedeth: expose module parameters in
 /sys/module
Message-ID: <20111115143359.781ba295@s6510.linuxnetplumber.net>
In-Reply-To: <558f3ff3d373b1cdcbebebe842816b3c91438728.1321384662.git.david.decotigny@google.com>
References: <cover.1321384662.git.david.decotigny@google.com>
	<558f3ff3d373b1cdcbebebe842816b3c91438728.1321384662.git.david.decotigny@google.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Nov 2011 11:25:37 -0800
David Decotigny <david.decotigny@google.com> wrote:

> +module_param(msi, int, S_IRUGO);
>  MODULE_PARM_DESC(msi, "MSI interrupts are enabled by setting to 1 and disabled by setting to 0.");
> -module_param(msix, int, 0);
> +module_param(msix, int, S_IRUGO);
>  MODULE_PARM_DESC(msix, "MSIX interrupts are enabled by setting to 1 and disabled by setting to 0.");
> -module_param(dma_64bit, int, 0);
> +module_param(dma_64bit, int, S_IRUGO);

Once again these attributes are visible through other means (/proc/interrupts for MSI)
and the 64bit dma is NETIF_F_HIGHDMA. They shouldn't be module parameters.
