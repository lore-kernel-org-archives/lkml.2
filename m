Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2BVQoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:44:14 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:53621 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752639Ab2BVQoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:44:12 -0500
Date: Wed, 22 Feb 2012 11:44:02 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, efi: Fix unaligned access and endian issues
Message-ID: <20120222164402.GA13354@elliptictech.com>
References: <1329919208-8700-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329919208-8700-1-git-send-email-matt@console-pimps.org>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-22 14:00 +0000, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> We need to read from and write to 'buf' a byte at a time otherwise
> it's possible we'll perform an unaligned access, which can lead to a
> segfault when cross-building an x86 kernel on risc architectures.
> 
> Also, we may need to convert the endianness of the data we read
> from/write to buf, so let's add some helper functions to do that.
[...]
> +static inline u32 read32_le(u8 *src)
> +{
> +	u32 data;
> +
> +	data = *src++;
> +	data |= *src++ << 8;
> +	data |= *src++ << 16;
> +	data |= *src++ << 24;
> +
> +	return data;
> +}

We already have get_unaligned_le32 in <asm/unaligned.h> for this.

> +
> +static inline void write32_le(u8 *dst, u32 data)
> +{
> +	*dst++ = data;
> +	*dst++ = data >> 8;
> +	*dst++ = data >> 16;
> +	*dst++ = data >> 24;
> +}

Similarly, put_unaligned_le32.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

