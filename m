Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab2GCMqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 08:46:34 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:2029 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932306Ab2GCMq2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 08:46:28 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI9371Izz1202hzz8275bhz2dh2a8h668h839h8e2h8e3hf0ahbe9i)
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Zhao Chenhui-B35336 <B35336@freescale.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/5] powerpc/85xx: implement hardware timebase sync
Thread-Topic: [PATCH v7 1/5] powerpc/85xx: implement hardware timebase sync
Thread-Index: AQHNWRnaavpowtpO5UeeCNsHPM8rhA==
Date: Tue, 3 Jul 2012 12:46:24 +0000
Message-ID: <CAOZdJXUeY-_mmBLoA25_g4eLqwHxYX4c_ECbU+KYqfM307THNQ@mail.gmail.com>
References: <1341310879-5468-1-git-send-email-chenhui.zhao@freescale.com>
In-Reply-To: <1341310879-5468-1-git-send-email-chenhui.zhao@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [107.22.165.113]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <D328A282B0345A4984CCA3DE3554C45B@mgd.freescale.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 5:21 AM, Zhao Chenhui <chenhui.zhao@freescale.com> wrote:

> +       np = of_find_matching_node(NULL, mpc85xx_smp_guts_ids);
> +       if (np) {
> +               guts = of_iomap(np, 0);
> +               of_node_put(np);
> +               if (!guts) {
> +                       pr_err("%s: Could not map guts node address\n",
> +                                                               __func__);
> +                       return;
> +               }
> +               smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
> +               smp_85xx_ops.take_timebase = mpc85xx_take_timebase;
> +       }

I had this in mind:

               guts = of_iomap(np, 0);
               of_node_put(np);
               if (guts) {
                       smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
                       smp_85xx_ops.take_timebase = mpc85xx_take_timebase;
                } else {
                       pr_err("%s: Could not map guts node address\n",
                                                               __func__);
               }

That way, a missing GUTS node does not break everything.

-- 
Timur Tabi
Linux kernel developer at Freescale
