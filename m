Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1CVQ0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 12:26:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:47745 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab1CVQ0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 12:26:33 -0400
Date: Tue, 22 Mar 2011 09:26:03 -0700
From: Greg KH <gregkh@suse.de>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, david@woodhou.se
Subject: Re: [PATCH 6/7] char/mei: Header file contain the Userland API,
 (IOCTL and its struct)
Message-ID: <20110322162603.GB14737@suse.de>
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
 <1300791092-14319-7-git-send-email-oren.jer.weil@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300791092-14319-7-git-send-email-oren.jer.weil@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 12:51:31PM +0200, Oren Weil wrote:
> +/*
> + * Intel MEI client information struct
> + */
> +struct mei_client {
> +	u32 max_msg_length;
> +	u8 protocol_version;
> +	u8 reserved[3];
> +} __packed;

As this is passing the kernel/user boundry, you need to use the proper
data types for it.

So use __u32 and __u8 here please.

> +/*
> + * IOCTL Connect Client Data structure
> + */
> +struct mei_connect_client_data {
> +	union {
> +		uuid_le in_client_uuid;
> +		struct mei_client out_client_propeties;
> +	} d;

Why not an anonymous union?

thanks,

greg k-h
