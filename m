Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab2BIIwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 03:52:45 -0500
Received: from narfation.org ([79.140.41.39]:46920 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab2BIIwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 03:52:43 -0500
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Feb 2012 03:52:43 EST
From: Sven Eckelmann <sven@narfation.org>
To: b.a.t.m.a.n@lists.open-mesh.org
Cc: Danny Kukawka <danny.kukawka@bisect.de>,
        Marek Lindner <lindner_marek@yahoo.de>, netdev@vger.kernel.org,
        Danny Kukawka <dkukawka@suse.de>, linux-kernel@vger.kernel.org,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [B.A.T.M.A.N.] [PATCH 40/50] batman-adv: use dev_hw_addr_random() instead of random_ether_addr()
Date: Thu, 09 Feb 2012 09:44:12 +0100
Message-ID: <4131504.bFpDbrJZp3@sven-laptop.home.narfation.org>
User-Agent: KMail/4.7.4 (Linux/3.1.0-1-686-pae; KDE/4.7.4; i686; ; )
In-Reply-To: <1328735457-29986-41-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de> <1328735457-29986-41-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart14017467.JRCiTb72lR"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart14017467.JRCiTb72lR
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

On Wednesday 08 February 2012 22:10:47 Danny Kukawka wrote:
> Use dev_hw_addr_random() instead of calling random_ether_addr()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.
> 
> Reset the state to NET_ADDR_PERM as soon as the MAC get
> changed via .ndo_set_mac_address.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  net/batman-adv/soft-interface.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/batman-adv/soft-interface.c
> b/net/batman-adv/soft-interface.c index 987c75a..865a485 100644
> --- a/net/batman-adv/soft-interface.c
> +++ b/net/batman-adv/soft-interface.c
> @@ -541,6 +541,9 @@ static int interface_set_mac_addr(struct net_device
> *dev, void *p) }
> 
>  	memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
> +	if (dev->addr_assign_type & NET_ADDR_RANDOM)
> +		dev->addr_assign_type ^= NET_ADDR_RANDOM;
> +
>  	return 0;
>  }

Why not something like

dev->addr_assign_type &= ~NET_ADDR_RANDOM;

? It is a relative common way inside the kernel to do this kind of stuff.

Thanks,
	Sven

PS: For the batman-adv people. This functionality was introduced with 2.6.36. 
--nextPart14017467.JRCiTb72lR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJPM4dcAAoJEF2HCgfBJntGnHUP/3Vrc6d5QO0uEbhtNFkCLn+k
0bRP1ad4SpSC4a94B8/cblQ/HXujqE1fvVkZrtRKss6gkhYLFwOzBvKff0cOt658
v8i7jRfo4REKjdHUWFZtyUX+SnE+IXbJ3UbxJNoRwUq+WamI5aCNKBGBaHWIx2rS
CkEZuWSc7U9g1Ic74gycS7AmLr/nCRcTRxq2Z1XieCUB81atAG5SfwdvYlWIka9p
OWp+uPKdMQ2w+nEpwJgTdXnR3aRe5eVuiHgqGBlPRAWEgfgidLWqLSO5Hx2k4tnw
cG5y4N/BKcF0tv5Yy24Y9C1SVyWNPwUi8xeHnpqZO9RTlkuCnykLi6q/tKZiC8kQ
22fWSmRIc/qL4AzEuSHART4Ejtd8haoszIWTw00vCWstEkqo7K/xY2uzGEZdeH5T
i6zH1XxtBnGDYCODTCdSD/J33s348cDdSrfpNPubYpcxBvIaKnjpDVNK1sAmVf46
LiJfCM5d/6FqhNnkUg6lCMRv/Qiu4NiexzmzNR0HNswSPTZDqvTAK2XUwUciMQBN
5Ks7KEXttyRksSesYHM3lI6Ig0+OOX6jUWEHmguK1FnC6WsDEFXC35S9EvPa2GmK
ggHlJfmBqHO+wQwvLmf0tH0S2ADogCtHel70ciI8G2qSDc8A3t0POqa5Hu0E34FZ
wpjyK1883XjbbsfK4msM
=r1h5
-----END PGP SIGNATURE-----

--nextPart14017467.JRCiTb72lR--

