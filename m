Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0KCRFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:05:16 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:15930 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab0KCRFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:05:14 -0400
Message-ID: <4CD19649.9060300@caviumnetworks.com>
Date: Wed, 03 Nov 2010 10:05:13 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: cdhmanning@gmail.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/9] Add yaffs ecc, mtd access and nand abstraction code
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <1288803204-3849-5-git-send-email-cdhmanning@gmail.com>
In-Reply-To: <1288803204-3849-5-git-send-email-cdhmanning@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2010 17:05:48.0954 (UTC) FILETIME=[5CDE8FA0:01CB7B79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 09:53 AM, cdhmanning@gmail.com wrote:
> From: Charles Manning<cdhmanning@gmail.com>
[...]
> --- /dev/null
> +++ b/fs/yaffs2/yaffs_ecc.c
[...]
> +
> +/* Count the bits in an unsigned char or a U32 */
> +
> +static int yaffs_count_bits(unsigned char x)
> +{
> +	int r = 0;
> +	while (x) {
> +		if (x&  1)
> +			r++;
> +		x>>= 1;
> +	}
> +	return r;
> +}
> +
> +static int yaffs_count_bits32(unsigned x)
> +{
> +	int r = 0;
> +	while (x) {
> +		if (x&  1)
> +			r++;
> +		x>>= 1;
> +	}
> +	return r;
> +}
> +

These two can probably be replaced with the standard hweight32() and 
hweight8().

David Daney
