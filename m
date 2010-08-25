Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0HYVYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 17:24:54 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41123 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab0HYVYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 17:24:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C758A00.5070203@s5r6.in-berlin.de>
Date: Wed, 25 Aug 2010 23:24:16 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Rotari Razvan-Gabriel <razvanrotari@gmail.com>
CC: clemens@ladisch.de, gregkh@suse.de, tj@kernel.org,
        dbrownell@users.sourceforge.net, andre.goddard@gmail.com,
        jkosina@suse.cz, davem@davemloft.net, shemminger@vyatta.com,
        eric.dumazet@gmail.com, martin.petersen@oracle.com,
        jens.axboe@oracle.com, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers: firewire: Fixed coding style for all the files
 in the directory
References: <1282769940-18492-1-git-send-email-razvanrotari@gmail.com>
In-Reply-To: <1282769940-18492-1-git-send-email-razvanrotari@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rotari Razvan-Gabriel wrote:
> Fixed coding style for all the filles in the directory
> 
> Signed-off-by: Rotari Razvan-Gabriel <razvanrotari@gmail.com>
> ---
>  drivers/firewire/core-card.c        |   12 ++++----
>  drivers/firewire/core-cdev.c        |   52 +++++++++++++++++++++++-----------
>  drivers/firewire/core-device.c      |   32 +++++++++++++--------
>  drivers/firewire/core-iso.c         |    4 +-
>  drivers/firewire/core-topology.c    |    6 ++--
>  drivers/firewire/core-transaction.c |   30 ++++++++++----------
>  drivers/firewire/net.c              |   26 +++++++++---------
>  drivers/firewire/ohci.c             |   26 +++++++++---------
>  drivers/firewire/sbp2.c             |   30 ++++++++++----------
>  9 files changed, 122 insertions(+), 96 deletions(-)
> 
> diff --git a/drivers/firewire/core-card.c b/drivers/firewire/core-card.c
> index be04923..4f0312c 100644
> --- a/drivers/firewire/core-card.c
> +++ b/drivers/firewire/core-card.c
> @@ -107,7 +107,7 @@ static void generate_config_rom(struct fw_card *card, __be32 *config_rom)
>  	j = 7 + descriptor_count;
> 
>  	/* Generate root directory entries for descriptors. */
> -	list_for_each_entry (desc, &descriptor_list, link) {
> +	list_for_each_entry(desc, &descriptor_list, link) {
>  		if (desc->immediate > 0)
>  			config_rom[i++] = cpu_to_be32(desc->immediate);
>  		config_rom[i] = cpu_to_be32(desc->key | (j - i));

Not a fix.

[...]
> @@ -439,7 +439,7 @@ static void bm_work(struct work_struct *work)
>  		new_root_id = local_id;
>  	}
> 
> - pick_me:
> +pick_me:
>  	/*
>  	 * Pick a gap count from 1394a table E-1.  The table doesn't cover
>  	 * the typically much larger 1394b beta repeater delays though.

Not a fix.

> @@ -1179,9 +1179,15 @@ static int ioctl_get_cycle_timer2(struct client *client, union ioctl_arg *arg)
>  	cycle_time = card->driver->read_csr(card, CSR_CYCLE_TIME);
> 
>  	switch (a->clk_id) {
> -	case CLOCK_REALTIME:      getnstimeofday(&ts);                   break;
> -	case CLOCK_MONOTONIC:     do_posix_clock_monotonic_gettime(&ts); break;
> -	case CLOCK_MONOTONIC_RAW: getrawmonotonic(&ts);                  break;
> +	case CLOCK_REALTIME:
> +		getnstimeofday(&ts);
> +		break;
> +	case CLOCK_MONOTONIC:
> +		do_posix_clock_monotonic_gettime(&ts);
> +		break;
> +	case CLOCK_MONOTONIC_RAW:
> +		getrawmonotonic(&ts);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  	}

Not a fix.

> @@ -319,9 +319,9 @@ static struct fw_node *build_tree(struct fw_card *card,
>  	return local_node;
>  }
> 
> -typedef void (*fw_node_callback_t)(struct fw_card * card,
> -				   struct fw_node * node,
> -				   struct fw_node * parent);
> +typedef void (*fw_node_callback_t)(struct fw_card *card,
> +				   struct fw_node *node,
> +				   struct fw_node *parent);
> 
>  static void for_each_fw_node(struct fw_card *card, struct fw_node *root,
>  			     fw_node_callback_t callback)

Good.

> @@ -495,20 +495,20 @@ static struct fw_address_handler *lookup_enclosing_address_handler(
>  static DEFINE_SPINLOCK(address_handler_lock);
>  static LIST_HEAD(address_handler_list);
> 
> -const struct fw_address_region fw_high_memory_region =
> -	{ .start = 0x000100000000ULL, .end = 0xffffe0000000ULL,  };
> +const struct fw_address_region fw_high_memory_region = {
> +	.start = 0x000100000000ULL, .end = 0xffffe0000000ULL,  };
>  EXPORT_SYMBOL(fw_high_memory_region);
> 
>  #if 0
> -const struct fw_address_region fw_low_memory_region =
> -	{ .start = 0x000000000000ULL, .end = 0x000100000000ULL,  };
> -const struct fw_address_region fw_private_region =
> -	{ .start = 0xffffe0000000ULL, .end = 0xfffff0000000ULL,  };
> -const struct fw_address_region fw_csr_region =
> -	{ .start = CSR_REGISTER_BASE,
> +const struct fw_address_region fw_low_memory_region = {
> +	.start = 0x000000000000ULL, .end = 0x000100000000ULL,  };
> +const struct fw_address_region fw_private_region = {
> +	.start = 0xffffe0000000ULL, .end = 0xfffff0000000ULL,  };
> +const struct fw_address_region fw_csr_region = {
> +	.start = CSR_REGISTER_BASE,
>  	  .end   = CSR_REGISTER_BASE | CSR_CONFIG_ROM_END,  };
> -const struct fw_address_region fw_unit_space_region =
> -	{ .start = 0xfffff0000900ULL, .end = 0x1000000000000ULL, };
> +const struct fw_address_region fw_unit_space_region = {
> +	.start = 0xfffff0000900ULL, .end = 0x1000000000000ULL, };
>  #endif  /*  0  */
> 
>  static bool is_in_fcp_region(u64 offset, size_t length)
> @@ -975,8 +975,8 @@ void fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
>  }
>  EXPORT_SYMBOL(fw_core_handle_response);
> 
> -static const struct fw_address_region topology_map_region =
> -	{ .start = CSR_REGISTER_BASE | CSR_TOPOLOGY_MAP,
> +static const struct fw_address_region topology_map_region = {
> +	.start = CSR_REGISTER_BASE | CSR_TOPOLOGY_MAP,
>  	  .end   = CSR_REGISTER_BASE | CSR_TOPOLOGY_MAP_END, };
> 
>  static void handle_topology_map(struct fw_card *card, struct fw_request *request,

This makes it worse.
I suggest just leave that as it is.

[...]
> @@ -1011,7 +1011,7 @@ static int fwnet_send_packet(struct fwnet_packet_task *ptask)
> 
>  	default:
>  		BUG();
> -	}
> +}
>  	if (ptask->dest_node == IEEE1394_ALL_NODES) {
>  		u8 *p;
>  		int generation;

Wrong.

[...]
> @@ -328,7 +328,7 @@ static void log_irqs(u32 evt)
>  }
> 
>  static const char *speed[] = {
> -	[0] = "S100", [1] = "S200", [2] = "S400",    [3] = "beta",
> +	[0] = "S100", [1] = "S200", [2] = "S400", [3] = "beta",
>  };
>  static const char *power[] = {
>  	[0] = "+0W",  [1] = "+15W", [2] = "+30W",    [3] = "+45W",

Notice the column alignment in power[].

> @@ -651,7 +651,7 @@ static __le32 *handle_ar_packet(struct ar_context *ctx, __le32 *buffer)
>  		p.payload_length = 0;
>  		break;
> 
> -	case TCODE_READ_BLOCK_REQUEST :
> +	case TCODE_READ_BLOCK_REQUEST:
>  		p.header[3] = cond_le32_to_cpu(buffer[3]);
>  		p.header_length = 16;
>  		p.payload_length = 0;

OK.

[...]
> @@ -262,7 +262,7 @@ struct sbp2_orb {
>  	dma_addr_t request_bus;
>  	int rcode;
>  	struct sbp2_pointer pointer;
> -	void (*callback)(struct sbp2_orb * orb, struct sbp2_status * status);
> +	void (*callback)(struct sbp2_orb *orb, struct sbp2_status *status);
>  	struct list_head link;
>  };
> 

OK.

> @@ -321,7 +321,7 @@ struct sbp2_command_orb {
>  	dma_addr_t page_table_bus;
>  };
> 
> -#define SBP2_ROM_VALUE_WILDCARD ~0         /* match all */
> +#define SBP2_ROM_VALUE_WILDCARD (~0)       /* match all */
>  #define SBP2_ROM_VALUE_MISSING  0xff000000 /* not present in the unit dir. */
> 
>  /*

As unnecessary as it can get.

--------

I kindly suggest you read Documentation/CodingStyle again.  But the version
that Linus originally wrote, not that abomination that this text has become in
the last two or three years.

Furthermore, don't use "checkpatch.p -f" if you don't also plan to read the
result.
-- 
Stefan Richter
-=====-==-=- =--- ==--=
http://arcgraph.de/sr/
