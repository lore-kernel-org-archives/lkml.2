Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab1KOWch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:32:37 -0500
Received: from mail.vyatta.com ([76.74.103.46]:59035 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211Ab1KOWcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:32:36 -0500
Date: Tue, 15 Nov 2011 14:32:31 -0800
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
Message-ID: <20111115143231.454f612a@s6510.linuxnetplumber.net>
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

> +module_param(optimization_mode, int, S_IRUGO);
>  MODULE_PARM_DESC(optimization_mode, "In throughput mode (0), every tx & rx packet will generate an interrupt. In CPU mode (1), interrupts are controlled by a timer. In dynamic mode (2), the mode toggles between throughput and CPU mode based on network load.");

Probably the original developer (or marketing data sheet), thought this was some
unique feature of the hardware. But most devices have this already.

This driver should just implement proper control irq coalescing control via ethtool
and get rid of the silly module parameter.

