Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2BOTPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:15:47 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38819 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab2BOTPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:15:45 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 15 Feb 2012 20:15:09 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 04/11] firewire-sbp-target: Add sbp_base.h header
Message-ID: <20120215201509.37949cb0@stein>
In-Reply-To: <1329317248-94128-5-git-send-email-bootc@bootc.net>
References: <1328989452-20921-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-5-git-send-email-bootc@bootc.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 15 Chris Boot wrote:
> --- /dev/null
> +++ b/drivers/target/sbp/sbp_base.h
> @@ -0,0 +1,204 @@
[...]
> +struct sbp2_pointer {
> +	__be32 high;
> +	__be32 low;
> +};
[...]
> +struct sbp_tport {
> +	/* Target Unit Identifier (EUI-64) */
> +	u64 guid;
> +	/* Target port name */
> +	char tport_name[SBP_NAMELEN];
> +	/* Returned by sbp_make_tport() */
> +	struct se_wwn tport_wwn;
> +
> +	struct sbp_tpg *tpg;
> +
> +	/* FireWire unit directory */
> +	struct fw_descriptor unit_directory;
> +
> +	/* SBP Management Agent */
> +	struct sbp_management_agent *mgt_agt;
> +
> +	/* Parameters */
> +	int enable;
> +	s32 directory_id;
> +	int mgt_orb_timeout;
> +	int max_reconnect_timeout;
> +	int max_logins_per_lun;
> +};
> +
> +extern struct target_fabric_configfs *sbp_fabric_configfs;
> +extern const struct fw_address_region sbp_register_region;
> +extern struct workqueue_struct *sbp_workqueue;
[...]

Generally, any source file (.c or .h) is meant to be self-contained WRT
type definitions etc., meaning that they should have all required
#include's in themselves rather than rely on indirect includes.

So here you should include the headers which define __be32, u64, struct
se_wwn, struct workqueue and so on.
-- 
Stefan Richter
-=====-===-- --=- -====
http://arcgraph.de/sr/
