Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352Ab2EPRlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:41:20 -0400
Received: from relay01ant.iops.be ([212.53.4.34]:46325 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab2EPRlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:41:18 -0400
Message-ID: <4FB3E6B8.7050909@acm.org>
Date: Wed, 16 May 2012 17:41:12 +0000
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: SCSI RAM driver ported to 3.3 kernel for file system and I/O
 testing
References: <1337188023.3796.130.camel@schen9-DESK>
In-Reply-To: <1337188023.3796.130.camel@schen9-DESK>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/12 17:07, Tim Chen wrote:

> +/*
> + * SCSI requires quantities to be written MSB.  They're frequently misaligned,
> + * so don't mess about with cpu_to_beN, just access it byte-wise
> + */
> +static void scsi_ram_put_u32(unsigned char *addr, unsigned int data)
> +{
> +	addr[0] = data >> 24;
> +	addr[1] = data >> 16;
> +	addr[2] = data >> 8;
> +	addr[3] = data;
> +}
> +
> +static unsigned int scsi_ram_get_u16(unsigned char *addr)
> +{
> +	unsigned int data;
> +	data = addr[0] << 8;
> +	data |= addr[1];
> +
> +	return data;
> +}
> +
> +static unsigned int scsi_ram_get_u24(unsigned char *addr)
> +{
> +	unsigned int data;
> +	data = addr[0] << 16;
> +	data |= addr[1] << 8;
> +	data |= addr[2];
> +
> +	return data;
> +}
> +
> +static unsigned int scsi_ram_get_u32(unsigned char *addr)
> +{
> +	unsigned int data;
> +	data = addr[0] << 24;
> +	data |= addr[1] << 16;
> +	data |= addr[2] << 8;
> +	data |= addr[3];
> +
> +	return data;
> +}


Please drop these functions and use get/put_unaligned_be*() instead.
Maybe it's a good idea to add get/put_unaligned_be24() helper functions
in the appropriate <linux/unaligned/...> header file - there is more
SCSI code that stores and retrieves 24-bit numbers.

Thanks,

Bart.
