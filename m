Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1BWS3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:29:08 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:41681 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1BWS3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:29:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Q9gijRlT5S7QK4RAG0OPjBb+VnQzoLagEF3Nwfvf+nBYdS5hnhW29EtAGWuylK0Bhr
         1ywZahAoDFZB5N8tqcU9SDQyBAuMPe5AScAsNg9H0B2tn+GnVy50i3AtPIEZeLAkamsq
         E5dNCcKsrEZviPe+57cDalUb/eWJddcsbMSWA=
Message-ID: <4D6551EF.70207@gmail.com>
Date: Wed, 23 Feb 2011 12:29:03 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 02/15] dt: add a match table pointer to struct device
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6> <20110223043345.20795.2936.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043345.20795.2936.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

On 02/22/2011 10:33 PM, Grant Likely wrote:
> Add a new .of_match field to struct device which points at the
> matching device driver .of_match_table entry when a device is probed
> via the device tree
>
> Signed-off-by: Grant Likely<grant.likely@secretlab.ca>
> ---
>   include/linux/device.h    |    1 +
>   include/linux/of_device.h |    5 +++--
>   2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/device.h b/include/linux/device.h
> index ca5d252..8d8e267 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -441,6 +441,7 @@ struct device {
>   	struct dev_archdata	archdata;
>
>   	struct device_node	*of_node; /* associated device tree node */
> +	const struct of_device_id *of_match; /* matching of_device_id from driver */

Couldn't of_match/of_match_table be merged into the platform dev/drv 
id_entry/id_table. Handling MODALIAS for a driver that does both OF 
style and normal platform device matching may be a problem though.

Rob
