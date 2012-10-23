Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965340Ab2JWUxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:53:21 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:53943 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964957Ab2JWUxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:53:16 -0400
Date: Tue, 23 Oct 2012 15:53:04 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH v2 2/4] zynq: move static peripheral mappings
Message-ID: <20121023205304.GJ20593@beefymiracle.amer.corp.natinst.com>
References: <20121022211219.GC31538@beefymiracle.amer.corp.natinst.com>
 <201210231450.11540.arnd@arndb.de>
 <5086F973.6050309@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5086F973.6050309@gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/23/2012 03:52:59 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/23/2012 03:52:59 PM,
	Serialize complete at 10/23/2012 03:52:59 PM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bFsKbPszpzYNtEU6"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-23_07:2012-10-23,2012-10-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bFsKbPszpzYNtEU6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 23, 2012 at 03:09:23PM -0500, Rob Herring wrote:
> On 10/23/2012 09:50 AM, Arnd Bergmann wrote:
> > On Monday 22 October 2012, Josh Cartwright wrote:
> >> -#define SCU_PERIPH_PHYS			0xF8F00000
> >> -#define SCU_PERIPH_VIRT			SCU_PERIPH_PHYS
> >> +#define SCU_PERIPH_PHYS		0xF8F00000
> >> +#define SCU_PERIPH_SIZE		SZ_8K
> >> +#define SCU_PERIPH_VIRT		(PL310_L2CC_VIRT - SCU_PERIPH_SIZE)
> >
> > And your patch 3 already obsoletes this mapping.
>
> Actually, it's probably still needed. The smp platform code typically
> reads the number of cores from the SCU and the mapping has to be in
> place before ioremap is up. I don't think there is an architected way to
> get the number of cores, but it would be nice to avoid this early SCU
> access. We could also mandate getting the core count from DT instead.
>
> Also, the physical address can be read with this on A9's:
>
>         asm("mrc p15, 4, %0, c15, c0, 0" : "=r" (base));

For the sake of the zynq cleanups, I think it may still make sense to
remove the SCU peripheral mappings for now.  By the time we're ready to
push in SMP support for zynq, maybe we can tackle the problem of how to
solve the SCU mapping problem generically.

If we're already considering a architecture-agnostic way to maintain the
early uart mapping, would it make sense to handle this in a similar way?

Thanks,

  Josh

--bFsKbPszpzYNtEU6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhwOvAAoJEEef0niEbw+l6+cP/R4847tqF+WWE5Y6JSGuBW64
5jYrCKYCYrXUDOExLuWggud8CgUE+f8kY3FM8rpBe0rZ4tIsnnQrUmaooYeEKDvk
RhZweB8MW+aVceuG5o+VdZ6kMkwPop7eDDNM6/Zx5EguJdh8FM0MGLPMXpB4ZVn5
iArGtcsvk/CQQ9gjC+eeqx2wkowFp9Sn0vUsPJaXMBjffPsTgQ74w1H3ItG1yv8s
VkEb4EtXtCPmL4YJ0i50egVw3kfH5Wn0hgpPOpb6CsONRkrEo5ydykif3GS8PAgg
B13R0ek6QBZ3ogskZUpO0G4gjHEiuy+0/LGw4z17PHbuljALaYfiHs1dn3D6s+8T
AOWl89Ha+FnANx5yUabsa+0r9Tc6fozd8fTZ6ha+4FCMDD9m5Q5G7Gx4JFiHydXf
+5vmu6pyLcM7th2e8vQf+Ubiv6MAL8nRAqBq/DdjCjHsM9P4UuR0B/Hz80RaYiBq
RvOeFqMDtptQXc8Lq9ec7eYnOzTpttNDjkGkMFZzj9qstR/+mYuJhw3gaTitDmvR
D4HoKj51AFKWqLN9VMnu9Hz2EVao/HpeQgQFAq7HR0ST75Ah70RtvC7J4JL05Jo2
5HhzqazNogehRiBebU4QZhwOI0YjsNfseAcMOsVEVHTDn97ecytwKzLZW7Aqriqm
jA3VDj0+TXQvOz3SM58I
=Ifhv
-----END PGP SIGNATURE-----

--bFsKbPszpzYNtEU6--
