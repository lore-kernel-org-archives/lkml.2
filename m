Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab2A3Loc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 06:44:32 -0500
Received: from mx0.aculab.com ([213.249.233.131]:34100 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752203Ab2A3Loa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 06:44:30 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [07/22] Cyclades PC300 driver: ioctl() fixes for mixed 64/32-bit systems
Date: Mon, 30 Jan 2012 11:44:10 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E3F@saturn3.aculab.com>
In-Reply-To: <20120130024929.GH10262@cronus.persephoneslair.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [07/22] Cyclades PC300 driver: ioctl() fixes for mixed 64/32-bit systems
Thread-Index: Acze+iY2JL3pHPipTj6BDwQdRyICRwASfGlw
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Andrea Shepard" <andrea@persephoneslair.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: <khc@pm.waw.pl>, <davem@davemloft.net>, <mmarek@suse.cz>,
        <jkosina@suse.cz>, <joe@perches.com>, <justinmattock@gmail.com>,
        <gregkh@suse.de>, <alan@linux.intel.com>, <jdmason@kudzu.us>
X-OriginalArrivalTime: 30 Jan 2012 11:44:14.0004 (UTC) FILETIME=[7D4F9740:01CCDF44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> +struct pc300_net_stats {
> +	u64 rx_packets;
...
> +	u64 rx_compressed;
> +	u64 tx_compressed;
> +};
> +
>  typedef struct pc300stats {
>  	int hw_type;
>  	u32 line_on;
>  	u32 line_off;
> -	struct net_device_stats gen_stats;
> +	/* Use this instead of net_device_stats, since passing
> +	 * net_device_stats breaks 32-bit user processes on 
> 64-bit kernels,
> +	 * and rtnetlink is unreasonably complicated just to get
> +	 * some statistics.
> +	 */
> +	struct pc300_net_stats net_stats;
>  	falc_t te_stats;
>  } pc300stats_t;

Since 'struct net_device_stats' looks like a common structure,
maybe the 64bit version should be added in the same place??

...
> +struct pc300hw_user {
> +	int type;               /* RSV, X21, etc. */
> +	int bus;                /* Bus (PCI, PMC, etc.) */
> +	int nchan;              /* number of channels */
> +	int irq;                /* interrupt request level */
> +	u32 clock;              /* Board clock */
> +	u8 cpld_id;             /* CPLD ID (TE only) */
> +	u16 cpld_reg1;          /* CPLD reg 1 (TE only) */

You should probably make all the fields fixed sized types and
ensure there is no implicit padding added between fields.

	David


