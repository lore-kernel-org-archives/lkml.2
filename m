Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab1KOW1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:27:40 -0500
Received: from mail.vyatta.com ([76.74.103.46]:55313 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab1KOW1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:27:39 -0500
Date: Tue, 15 Nov 2011 14:27:33 -0800
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
        Ayaz Abdulla <AAbdulla@nvidia.com>, Sameer Nanda <snanda@google.com>
Subject: Re: [PATCH net-next v4 3/8] forcedeth: allow to silence "TX
 timeout" debug messages
Message-ID: <20111115142733.5f5ca457@s6510.linuxnetplumber.net>
In-Reply-To: <47650719c85908eb4dff05f5d243cc0e9e181748.1321384662.git.david.decotigny@google.com>
References: <cover.1321384662.git.david.decotigny@google.com>
	<47650719c85908eb4dff05f5d243cc0e9e181748.1321384662.git.david.decotigny@google.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Nov 2011 11:25:36 -0800
David Decotigny <david.decotigny@google.com> wrote:

> From: Sameer Nanda <snanda@google.com>
> 
> This adds a new module parameter "debug_tx_timeout" to silence most
> debug messages in case of TX timeout. These messages don't provide a
> signal/noise ratio high enough for production systems and, with ~30kB
> logged each time, they tend to add to a cascade effect if the system
> is already under stress (memory pressure, disk, etc.).
> 
> By default, the parameter is clear, meaning that only a single warning
> will be reported.
> 
> 
> 
> Signed-off-by: David Decotigny <david.decotigny@google.com>

This (and the counter) should really be generic. I know it is more annoying
to have to solve a generic problem, but putting my distributor hat on,
any solution that is specific to only one driver is not a solution that
is useful.

The control of tx_timeout should be a property of the device, and the statistic
should be available for all devices. There is a problem though, the existing
network device statistics structure is part of ABI and can't grow. You can
add new statistics to netlink and sysfs as attributes, but not for the older
static API's.


