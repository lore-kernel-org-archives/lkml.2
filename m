Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab1BHDap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 22:30:45 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:58481 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106Ab1BHDan convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 22:30:43 -0500
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        "'Wolfgang Grandegger'" <wg@grandegger.com>
Cc: "socketcan-core@lists.berlios.de" <socketcan-core@lists.berlios.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 8 Feb 2011 11:29:59 +0800
Subject: RE: About bittiming calculation result
Thread-Topic: About bittiming calculation result
Thread-Index: AcvGvnY9D/1fOfusQtWXGnU3k7EAIQAar9MgAAWxPiA=
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384DEE2BE1A7@EAPEX1MAIL1.st.com>
References: <cover.1296818921.git.segoon@openwall.com><a6800dc8b0daed78256f98f52844cbbb48f4a76d.1296818921.git.segoon@openwall.com><20110204124233.GB334@e-circ.dyndns.org>
	<20110204.130649.112613896.davem@davemloft.net>
	<5009516791F146C49C73FAC57C437313@hacdom.okisemi.com>
	<4D4FDEF9.2030305@grandegger.com>
 <E2BAACFF191C4175854E6B2EB9135BE5@hacdom.okisemi.com>
In-Reply-To: <E2BAACFF191C4175854E6B2EB9135BE5@hacdom.okisemi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomoya,

> -----Original Message-----
> From: socketcan-core-bounces@lists.berlios.de [mailto:socketcan-core-
> bounces@lists.berlios.de] On Behalf Of Tomoya MORINAGA
> Sent: Tuesday, February 08, 2011 6:40 AM
> To: 'Wolfgang Grandegger'
> Cc: socketcan-core@lists.berlios.de; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: RE: About bittiming calculation result
> 
> On Monday, February 07, 2011 9:01 PM, Wolfgang Grandegger wrote
> >
> > Well, only prop_seg+phase_seg=tseg1 is relevant and the
> > pch_can driver sets the allowed minimum "tseg1_min1" currently to 1:
> >
> > static struct can_bittiming_const pch_can_bittiming_const = {
> >         .name = KBUILD_MODNAME,
> >         .tseg1_min = 1,
> >         .tseg1_max = 16,
> >         .tseg2_min = 1,
> >         .tseg2_max = 8,
> >         .sjw_max = 4,
> >         .brp_min = 1,
> >         .brp_max = 1024, /* 6bit + extended 4bit */
> >         .brp_inc = 1,
> > };
> >
> > > seg1/seg2/sjw/prop_seg must be more than 1 ?
> >
> > Then "tseg1_min" should be set to *2*.
> 
> Though some drivers accepted by upstream have parameter "tseg1_min" as
> 1,
> Sould we release the patch like below ?
>  -         .tseg1_min = 1,
> +         .tseg1_min = 2,
> 
AFAIK pch uses the Bosch C_CAN core internally.
As per Bosch C_CAN user manual tseg1= prop_seg + phase_seg1
So, ideally tseg1_min should be 2. My version of Bosch C_CAN driver
Uses the value 2.

Regards,
Bhupesh
