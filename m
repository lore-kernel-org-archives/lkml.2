Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab2BPRff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 12:35:35 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9072 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2BPRfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 12:35:34 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 16 Feb 2012 09:35:30 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 16 Feb 2012 09:35:29 -0800
Subject: RE: [PATCH] pinctrl: Store mapping table as a list of chunks
Thread-Topic: [PATCH] pinctrl: Store mapping table as a list of chunks
Thread-Index: AczsJOVK6SBtwQxNRiuw7E6ixCUnqAArDpWg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1790EC873F@HQMAIL01.nvidia.com>
References: <1329339646-19472-1-git-send-email-swarren@nvidia.com>
In-Reply-To: <1329339646-19472-1-git-send-email-swarren@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren wrote at Wednesday, February 15, 2012 2:01 PM:
> Instead of storing a single array of mapping table entries, which
> requires realloc()ing that array each time it's extended and copying
> the new data, simply store a list of pointers to the individual chunks.
> This also removes the need to copy the mapping table at all; a pointer
> is maintained to the original table, this saving memory.
...
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
...
> @@ -689,31 +719,17 @@ int __init pinctrl_register_mappings(struct pinctrl_map const *maps,
...
> +	maps_node = kzalloc(sizeof(*maps), GFP_KERNEL);

That should be sizeof(*maps_node).

I'll post a respin of this with the rest of my pinctrl changes.

--
nvpublic

