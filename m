Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566Ab1KJHoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 02:44:12 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:48484 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757403Ab1KJHoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 02:44:10 -0500
Date: Thu, 10 Nov 2011 08:44:08 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Will Drewry <wad@chromium.org>, Elly Jones <ellyjones@chromium.org>,
        Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm: verity target
Message-ID: <20111110074408.GE10138@secunet.com>
References: <1320902290-19050-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320902290-19050-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Nov 2011 07:44:08.0509 (UTC) FILETIME=[8781BED0:01CC9F7C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 09:18:10PM -0800, Mandeep Singh Baines wrote:
>
> + * TODO(wad): All hash storage memory is pre-allocated and freed once an
> + * entire branch has been verified.
> + */
> +struct dm_bht {
> +	/* Configured values */
> +	int depth;  /* Depth of the tree including the root */
> +	unsigned int block_count;  /* Number of blocks hashed */
> +	unsigned int block_size;  /* Size of a hash block */
> +	char hash_alg[CRYPTO_MAX_ALG_NAME];
> +	unsigned char salt[DM_BHT_SALT_SIZE];
> +
> +	/* Computed values */
> +	unsigned int node_count;  /* Data size (in hashes) for each entry */
> +	unsigned int node_count_shift;  /* first bit set - 1 */
> +	/* There is one per CPU so that verified can be simultaneous. */
> +	struct hash_desc hash_desc[NR_CPUS];  /* Container for the hash alg */

Please don't add a new user for the old hash interface. If the hashes can
be done asynchronous you can use ahash, if not use shash. Both interfaces
are reentrant, that's probaply what you want to have here. You don't
need to have this in a per cpu manner.

