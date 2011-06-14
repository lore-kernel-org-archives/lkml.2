Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1FNLcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 07:32:04 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:34997 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756205Ab1FNLcB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 07:32:01 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz1432Nzz1202hzz8275bhz2fh2a8h668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: CIP:198.70.193.61;KIP:(null);UIP:(null);IPVD:NLI;H:avexcashub1.qlogic.com;RD:avexcashub1.qlogic.com;EFVD:NLI
From: Amit Salecha <amit.salecha@qlogic.com>
To: Joe Perches <joe@perches.com>, netdev <netdev@vger.kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
        Jie Yang <jie.yang@atheros.com>,
        Sathya Perla <sathya.perla@emulex.com>,
        Subbu Seetharaman <subbu.seetharaman@emulex.com>,
        Ajit Khaparde <ajit.khaparde@emulex.com>,
        Rasesh Mody <rmody@brocade.com>, Debashis Dutt <ddutt@brocade.com>,
        Sjur Braendeland <sjur.brandeland@stericsson.com>,
        Divy Le Ray <divy@chelsio.com>,
        Breno Leitao <leitao@linux.vnet.ibm.com>,
        Ron Mercer <ron.mercer@qlogic.com>,
        Linux Driver <Linux-Driver@qlogic.com>,
        Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
        Jon Mason <jdmason@kudzu.us>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Steve Hodgson <shodgson@solarflare.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Daniele Venzano <venza@brownhat.org>,
        David Dillow <dave@thedillows.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 14 Jun 2011 06:31:47 -0500
Subject: RE: [PATCH net-next 2/2] drivers/net: Remove casts of void *
Thread-Topic: [PATCH net-next 2/2] drivers/net: Remove casts of void *
Thread-Index: AcwqR/JMrrv69BLCSHGg9jpccQ0gKwAPm5+A
Message-ID: <99737F4847ED0A48AECC9F4A1974A4B80FDEEEA283@MNEXMB2.qlogic.org>
References: <cover.1308024069.git.joe@perches.com>
 <486a21b708a9dce0c1c0059a21a2f9b66dac9e3c.1308024069.git.joe@perches.com>
In-Reply-To: <486a21b708a9dce0c1c0059a21a2f9b66dac9e3c.1308024069.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Joe Perches [mailto:joe@perches.com]
>
> Unnecessary casts of void * clutter the code.
> 
> These are the remainder casts after several specific
> patches to remove netdev_priv and dev_priv.
> 
> Done via coccinelle script:
> 
> $ cat cast_void_pointer.cocci
> @@
> type T;
> T *pt;
> void *pv;
> @@
> 
> - pt = (T *)pv;
> + pt = pv;
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/netxen/netxen_nic_ctx.c |   16 ++++++------
>  drivers/net/qlcnic/qlcnic_ctx.c     |   26 ++++++++++----------
>  drivers/net/qlcnic/qlcnic_ethtool.c |    2 +-
>  drivers/net/qlcnic/qlcnic_hw.c      |    3 +-
>  drivers/net/qlcnic/qlcnic_main.c    |    2 +-

netxen_nic and qlcnic looks good.

-Amit

