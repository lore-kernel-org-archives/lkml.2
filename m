Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab2CKKkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 06:40:22 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42751 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2CKKkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 06:40:20 -0400
Date: Sun, 11 Mar 2012 13:42:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/4] Drivers: hv: Support the newly introduced KVP
 messages in the driver
Message-ID: <20120311104230.GC3337@mwanda>
References: <1331422300-4330-1-git-send-email-kys@microsoft.com>
 <1331422331-4381-1-git-send-email-kys@microsoft.com>
 <1331422331-4381-2-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s9fJI615cBHmzTOP"
Content-Disposition: inline
In-Reply-To: <1331422331-4381-2-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F5C8105.005A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s9fJI615cBHmzTOP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 10, 2012 at 03:32:09PM -0800, K. Y. Srinivasan wrote:
> +		switch (message->kvp_hdr.operation) {
> +		case KVP_OP_SET:
> +			switch (in_msg->body.kvp_set.data.value_type) {
> +			case REG_SZ:
> +				/*
> +				 * The value is a string - utf16 encoding.
> +				 */
> +				message->body.kvp_set.data.value_size =
> +				utf16s_to_utf8s(
> +				(wchar_t *)
> +				in_msg->body.kvp_set.data.value,
> +				in_msg->body.kvp_set.data.value_size,
> +				UTF16_LITTLE_ENDIAN,
> +				message->body.kvp_set.data.value,
> +				HV_KVP_EXCHANGE_MAX_VALUE_SIZE) + 1;
> +				break;
> +

This block of unreadable text is so nasty.

You could return directly if the msg = kmalloc() fails and pull
everything in one indent level.  It's normally more readable to
handle errors as soon as possible anyway.

Probably that's not enough to make a difference and we'd need to
introduce a new function.

Btw I don't know if utf16s_to_utf8s() counts the NUL char or not.
It feels like maybe we could end up with ->value_size equal to
HV_KVP_EXCHANGE_MAX_VALUE_SIZE + 1.

regards,
dan carpenter

--s9fJI615cBHmzTOP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPXIGWAAoJEOnZkXI/YHqRewIP/2FCLwjqyq4tApTNDfAmUqD1
G6EvsQpOjUuYcev8ZWbQ/6Dw6572vMy+DIiOXyFWG9HATGcSUaPl1KP2cCemOAHk
ycccaUP2xX5NM8rNREHxKHmCucRC+roZ1Ml1DcyQ/ftsyIJ8Se8trT55+u4DlwOD
Pm7rNZnQedtkr5OqWd0+LwbJFYeso3tqQHplPg2XAycx4uqSqsJK8HCbyMSBU+tR
Wfzd9f8Ml4SeHIFevVa1cEuWnHRipn9/ItGIgZ3yrcL7/Kv2LeKjCt8oiN8F7Yxg
Pi+kaSKKzU/XA50JsmIG9f5eY0gfTUNJ2wyQp62V6dMtqWp6PlupLBhDtgET1jMI
OciMuqxfmqhCgatqiZM3w1FHgnL7gYYST66Myoj5f2hBJ8aqZGhk2ok5aDrXHs55
wuIJ2MXyaDL8dhqY8C2Hj6FgJE3A9OnKBoD0p92Y+xwimfv8Bvh6XDdWnvUw1nSw
mApJBc1qCqo8LBbpCSSNVA5NvUIL/Fp62K2CCd8Kr0aGpP7plGmj/HV2yYG7lWPP
KwL2fOc3zysYO74g6z+xkD/bnWfZQ7awPSn3K5fmHG4J0qwYj0GnyKa0MEytOO8K
jtc+p7uO3YPvrxkskd7qtTYhYqLEi4Hc0pZEjuyVhMcioEXP6/QPVPp4pn/2XEHQ
tKK99ecllA4/qoSaU0HT
=Q0vO
-----END PGP SIGNATURE-----

--s9fJI615cBHmzTOP--
