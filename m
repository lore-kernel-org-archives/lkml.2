Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030336Ab2B2GUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 01:20:34 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:46902 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab2B2GUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 01:20:33 -0500
Date: Wed, 29 Feb 2012 09:22:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        linux-kernel@vger.kernel.org, Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 1/2] staging: zcache: fix length type mismatch
Message-ID: <20120229062220.GA22598@mwanda>
References: <1330466497-24361-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <1330466497-24361-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090206.4F4DC3A7.0007,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 28, 2012 at 04:01:37PM -0600, Seth Jennings wrote:
> This fixes a type mismatch in the compression code where
> a size_t pointer was cast to a unsigned int pointer.  On
> little endian archs, there is no issue.  However on big
> endian archs, the value is incorrect, taking the high
> order bits and truncating the lower order bits.

I would think this would be a problem on any 64bit machine not just
big endian ones.  Since clen is half uninitialized we would likely
hit the clen > zbud_max_buddy_size() test.

Anyway the patch is right.

regards,
dan carpenter



--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTcQbAAoJEOnZkXI/YHqRWhEP/R2RusP/mETgvc/nYmw8reNy
v3kQNhcHhCvzRX0ZtIYpFy4Vbu9qlJ9KDR1gA9zHsCAx3w5vc9jgsnwR64iiex7W
8vz7wknhLAg2Nw2BC/7c1RiGAYsC27wVLnuQnpuE2mdKXOx0CecD78i87vSkLqo3
hC7IWQsCYCs7Ncnb/otAYVkU0tTtE2Ziu+62rgAwQ1w7/2c0LfdCXtbeUgXnU0oD
rGoXnUqMI8EdIJwslA7zok24VbKqy2tA/jxT8G0plUCvu2v/puOYqVWrumLvnbaQ
JV+QgRMDLSh4SBieBcCo5d507hzZ0Yf4S/KYzrCxrSRWEGpd/Ev21qzdsllG7zs0
ONk4/U1nqzA0EQKs2oNeOSpWXPoNuwHvik+0+J8rflEUGWOoBxO0mz5GqmwDIwdt
VeuVOOUQtMhgboOhIRn6hoDLT0DwzIvnldu9hLJRYXwtPD8l3KNlzfWCaXAeNIPB
ULcxFYJxaY0wFvZ/EGls5kB1p/yKVlTk9p4bRW5d+F3HWXh0lp8+ozBb2RaiRp7E
vi8MvLv6F/3jhXod7u+u2lkZN7Cp0rxlr14+5DAj94JKJuXAUSokkVh9gIwefu+f
d/wOTX2t7d4cXUoECZZRy5lHrnX3jHUJxeD+PU6tN58zAMoQT9wBqlfkYiwAG/Vq
7BEQHt2xHHel2xq2DWsV
=ZEzQ
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
