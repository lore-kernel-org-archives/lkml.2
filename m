Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab1CVKoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:44:39 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:1679
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754746Ab1CVKog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:44:36 -0400
X-SpamScore: -7
X-BigFish: VPS-7(za62pz98dNzz1202hzz15d4Rz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LIGGHX-02-2Y0-02
X-M-MSG: 
Date: Tue, 22 Mar 2011 11:44:26 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Florian Mickler <florian@mickler.org>
CC: Andy Walls <awalls@md.metrocast.net>,
        "mchehab@infradead.org" <mchehab@infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "js@linuxtv.org" <js@linuxtv.org>,
        "tskd2@yahoo.co.jp" <tskd2@yahoo.co.jp>,
        "liplianin@me.by" <liplianin@me.by>,
        "g.marco@freenet.de" <g.marco@freenet.de>,
        "aet@rasterburn.org" <aet@rasterburn.org>,
        "pb@linuxtv.org" <pb@linuxtv.org>,
        "mkrufky@linuxtv.org" <mkrufky@linuxtv.org>,
        "nick@nick-andrew.net" <nick@nick-andrew.net>,
        "max@veneto.com" <max@veneto.com>,
        "janne-dvb@grunau.be" <janne-dvb@grunau.be>,
        Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/6] get rid of on-stack dma buffers
Message-ID: <20110322104426.GA20444@amd.com>
References: <1300732426-18958-1-git-send-email-florian@mickler.org>
 <a08d026a-d4c3-4ee5-b01a-d561f755b1ec@email.android.com>
 <20110321220315.7545a61a@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110321220315.7545a61a@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 05:03:15PM -0400, Florian Mickler wrote:
> I guess (not verified), that the dma api takes sufficient precautions
> to abort the dma transfer if a timeout happens.  So freeing _should_
> not be an issue. (At least, I would expect big fat warnings everywhere
> if that were the case)

Freeing is very well an issue. All you can expect from the DMA-API is to
give you a valid DMA handle for your device. But it can not prevent that
a device uses this handle after you returned it. You need to make sure
yourself that any pending DMA is canceled before calling kfree().


		Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

