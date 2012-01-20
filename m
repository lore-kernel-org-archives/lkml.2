Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab2ATLxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 06:53:16 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:62225 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2ATLxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 06:53:15 -0500
Date: Fri, 20 Jan 2012 14:54:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Pradheep Shrinivasan <pradheep.sh@gmail.com>, greg@kroah.com,
        devel@linuxdriverproject.org, swetland@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging:android_pmem.h: Fixes the space and other
 formating issues pointed out by checkpatch.pl
Message-ID: <20120120115408.GL3356@mwanda>
References: <1326856764-2531-1-git-send-email-pradheep.sh@gmail.com>
 <20120118065620.GE3294@mwanda>
 <CANz8tm1imZ3njy_uV0tkq0sXwyB5ZLLJsrp4G1zjcBDnJUrjiw@mail.gmail.com>
 <20120118185457.GH3356@mwanda>
 <CAAq6er0OPkvTCLt1DvHSjyqM4pH7GMb-D78M09cJY+1ZV3miiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qyHYMwAXsHLOQihY"
Content-Disposition: inline
In-Reply-To: <CAAq6er0OPkvTCLt1DvHSjyqM4pH7GMb-D78M09cJY+1ZV3miiQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F1955A4.00B8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qyHYMwAXsHLOQihY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

It still complains about the following macros where parenthesis are
not needed.

ERROR: Macros with complex values should be enclosed in parenthesis
#156: FILE: staging/android/pmem.c:156:
+#define PMEM_IS_FREE(id, index) !(pmem[id].bitmap[index].allocated)

Let's just make the check look for an operator with a low
precedence.
http://en.wikipedia.org/wiki/Order_of_operations#Programming_languages

Otherwise the submitters are going to change it to:

#define PMEM_IS_FREE(id, index) (!(pmem[id].bitmap[index].allocated))

That has two pairs of unneeded paranthesis and we run the risk of
reprogramming the kernel in lisp, by mistake.

regards,
dan carpenter

--qyHYMwAXsHLOQihY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPGVXgAAoJEOnZkXI/YHqR3IQP/jg95GqoUpsHrSI68kJp2B8S
9GeLGnLFKPYH21Jl0e0m6zsdUbfyJS/4vK0/0jmGGr2oXg9vsxcDtK6l7WM6en59
NuJMOlItPBPZZRVL3s3OuUd/cpg32zK26dxBoAJJLGgXy+ejiPOahhUC3CHFgINw
wb1VZZiOWV6Z0Ty9s2hWjwK+WFJ62SAy4vukTsINMk+NNzgtZXG7PRufBudGUwKy
HOWjdusdlpCZjnTQoRf4VztMfKGYDPb8kXY/9kFET6PPRA6cRN4FjwXq3suubveV
ks9Rax//sJ3G76425BMMRYM6yMmfSdjU1FB38XMIjW6kDJmcAi7OLBGLIDZONmvR
2yJzAKiBvuwrGqQjL50Vs4JltzUNK2k7DFmBPTC+o3NcFkKw6lSZWRiu2jR74/H2
yQBGhSRkbpEEl6t3Hc1p2LCEi0qhp7HULP93/AuepH+BrkNq563q23wdJUEQZYp6
8erEttlWIc7G5WsekXx4z5BXo7R00AUX0fN2veEBRk50eukCSOoAPLHb0tCVRMYU
NrDHNESWybjl4gIZceTzdP11FahUtAqXvHrrdpxzdYgOjkim42YwZxLfDqmVVuzJ
GeWVU0iFDNgtIwOajEW3Ar58JxaNFaJXPwRsWC5to/IqiLuQRhfaGBq55900m/j/
DRm+P6D/qLHXRqMfu637
=tdlS
-----END PGP SIGNATURE-----

--qyHYMwAXsHLOQihY--
