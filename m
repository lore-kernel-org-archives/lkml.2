Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413Ab2CUWPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:15:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44781 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab2CUWPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:15:20 -0400
Date: Wed, 21 Mar 2012 15:15:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        rcj@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 14/17] powerpc: crypto: nx driver code supporting nx
 encryption
Message-ID: <20120321221517.GB30748@kroah.com>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
 <1332366068.3858.50.camel@key-ThinkPad-W510>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332366068.3858.50.camel@key-ThinkPad-W510>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 04:41:08PM -0500, Kent Yoder wrote:
> +static int nx_register_algs(void)
> +{
> +	int rc = -1;
> +
> +	if (nx_driver.of.flags != NX_OF_FLAG_MASK_READY)
> +		goto out;
> +
> +	memset(&nx_driver.stats, 0, sizeof(struct nx_stats));
> +
> +	rc = nx_sysfs_init(&nx_driver.viodriver.driver);

Ok, that's not bad, you are doing it from the probe() function of your
bus.  As long as the bus got things right on when uevents get sent to
userspace, does it?

> +static struct vio_device_id nx_crypto_driver_ids[] __devinitdata = {
> +	{ "ibm,sym-encryption-v1", "ibm,sym-encryption" },
> +	{ "", "" }
> +};
> +MODULE_DEVICE_TABLE(vio, nx_crypto_driver_ids);
> +
> +/* driver state structure */
> +struct nx_crypto_driver nx_driver = {
> +	.viodriver = {
> +		.id_table = nx_crypto_driver_ids,
> +		.probe = nx_probe,
> +		.remove = nx_remove,
> +		.driver = {
> +			.name  = "nx",
> +			.owner = THIS_MODULE,
> +		},

Really?  vio drivers are supposed to look like this with the .name and
.owner field manually being set in the static initialization of the
driver?  That's sad, and should be fixed, the vio core should do this
type of thing for you.

greg k-h
