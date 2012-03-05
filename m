Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab2CEDr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 22:47:27 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53929 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab2CEDr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 22:47:26 -0500
Date: Mon, 5 Mar 2012 14:47:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20120305144715.6a50c71ae343761cfb99f80a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Mar_2012_14_47_15_+1100_ECFKtZuSy7Hqzu78"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Mar_2012_14_47_15_+1100_ECFKtZuSy7Hqzu78
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_ringbuffer.c between commit 5d031e5b633d
("drm/i915: Remove use of the autoreported ringbuffer HEAD position")
from Linus' tree and commit a71d8d94525e ("drm/i915: Record the tail at
each request and use it to estimate the head") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_ringbuffer.c
index 5361915,ca3972f..0000000
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@@ -1132,6 -1190,23 +1190,11 @@@ int intel_wait_ring_buffer(struct intel
  	struct drm_device *dev =3D ring->dev;
  	struct drm_i915_private *dev_priv =3D dev->dev_private;
  	unsigned long end;
+ 	int ret;
 -	u32 head;
 -
 -	/* If the reported head position has wrapped or hasn't advanced,
 -	 * fallback to the slow and accurate path.
 -	 */
 -	head =3D intel_read_status_page(ring, 4);
 -	if (head > ring->head) {
 -		ring->head =3D head;
 -		ring->space =3D ring_space(ring);
 -		if (ring->space >=3D n)
 -			return 0;
 -	}
+=20
+ 	ret =3D intel_ring_wait_request(ring, n);
+ 	if (ret !=3D -ENOSPC)
+ 		return ret;
 =20
  	trace_i915_ring_wait_begin(ring);
  	if (drm_core_check_feature(dev, DRIVER_GEM))

--Signature=_Mon__5_Mar_2012_14_47_15_+1100_ECFKtZuSy7Hqzu78
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPVDdDAAoJEECxmPOUX5FETPIP/jhl11qhAlR0WKx+N0kFGXs4
M9Df0IWxEYPojtTt9/uexGQ4tnCRSMcmwOEe0PKPbf4Q8oUzqN8BZjEyM1QoEAxh
tW/nSkztMyUtPmrvZ6U1xv51UuwVJY8Q/d6PZEziAjwTja1i3X1J+swfIbJ17Eps
giwh3YcNIg5twjwic5/XU/hohJZljwcNqQ/xHvRrBv6Tx7a9CaPqD3roIPI8PAwG
ifKK05QrfmpONtgp/DQi4Y1/zyxBD+IQO4C818LyzcY1YeiM/kg9eWMOsvhE5W+k
3/g3xZXZzsSimW1P3XEwYSb+3hY3aNpzIrGmB3ML+HmRcK8aFWHBpzF5FsbpgMv6
2PYkQ6/wgaY1+FUXVq8hs0DzxpX2AlAPN5Wn8gJLmpm1MakK/I3VLPps1PN3hdL/
e0j1K6pS9vb69IUK5UJuUCKu7JvpBS0MbHOqgZ3nXfyFa+fwTh8Fz6LomFEqxmNT
CPd3WYwgMQYamQg/C3ItENTML5dOziKusYpSMRbeNmVA1iDFhllOXEkKNl8RcyAN
lKEfziBvu6LfIsRmevAz38FUYdd+A7dbLcDybpQP1F64J2eiOU6ct3/lRXq606oV
POKNUtSKMqwQNmmgQaDa8u99xGbGgmTr/PiswMaoi18+HDUv6htJWdWbXbrkFytF
ZmkfzzajJg43waol5JIQ
=IpAt
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Mar_2012_14_47_15_+1100_ECFKtZuSy7Hqzu78--
