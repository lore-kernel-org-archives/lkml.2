Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab1LWLUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 06:20:13 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18487 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab1LWLUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 06:20:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 23 Dec 2011 03:20:07 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Alok Chauhan <alokc@nvidia.com>, Olof Johansson <olof@lixom.net>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        Stephen Warren <swarren@nvidia.com>,
        "bones@secretlab.ca" <bones@secretlab.ca>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dgreid@google.com" <dgreid@google.com>
Date: Fri, 23 Dec 2011 16:50:00 +0530
Subject: RE: [PATCH] i2c: tegra: Add delay before reset the controller
Thread-Topic: [PATCH] i2c: tegra: Add delay before reset the controller
Thread-Index: AczA9ZxzAn/Jn73iT+SgJWUzkwqrWAAbiW6gAAAfbDA=
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DBD3A93D3@BGMAIL01.nvidia.com>
References: <1324550480-26308-1-git-send-email-alokc@nvidia.com>
 <CAOesGMire-13yiA9gVQYFWdTa6ZLJLbTW8qoRoPMRQ1ExavVUQ@mail.gmail.com>
 <7A0BFCFE3DA5CD47B0FB7984326F201A134F2CCC73@BGMAIL01.nvidia.com>
In-Reply-To: <7A0BFCFE3DA5CD47B0FB7984326F201A134F2CCC73@BGMAIL01.nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alok Chauhan
> 
> Hi,
> 
> (Adding Laxman Dewangan)
> 
> >This change causes problems systems with some models of i2c TPMs, since the
> first transaction to them will always time out (TPM quirk), and the delay
> means that the tpm will have time to go back to sleep and thus timeout >even
> on the retry. So you'll never make progress.
> Working on this.
> 
> -Alok
> 
> 
> -----Original Message-----
> From: Olof Johansson [mailto:olof@lixom.net]
> Sent: Friday, December 23, 2011 2:48 AM
> To: Alok Chauhan
> Cc: khali@linux-fr.org; ben-linux@fluff.org; Stephen Warren;
> bones@secretlab.ca; paul.gortmaker@windriver.com; linux-i2c@vger.kernel.org;
> linux-kernel@vger.kernel.org; linux-tegra@vger.kernel.org; dgreid@google.com
> Subject: Re: [PATCH] i2c: tegra: Add delay before reset the controller
> 
> Hi,
> 
> (Adding linux-tegra and Dylan Reid who was debugging this before)
> 
> On Thu, Dec 22, 2011 at 2:41 AM, Alok Chauhan <alokc@nvidia.com> wrote:
> > From: Alok Chauhan <alokc@nvidia.com>
> >
> > In NACK error condition, I2C controller violates clock-to-data setup
> > time before stop. In Software, because of this reset of controller is
> > happening before I2C controller could complete STOP condition.
> >
> > Added worst case delay of 1 ms (assuming lowest clock frequency will
> > be 1 KHZ) before reset the controller in case of NACK error.
> 
> This change causes problems systems with some models of i2c TPMs, since the
> first transaction to them will always time out (TPM quirk), and the delay
> means that the tpm will have time to go back to sleep and thus timeout even on
> the retry. So you'll never make progress.
> 
> In other words: this patch will break some systems and thus shouldn't be
> applied.
> 
I think the  delay should be calculated based on speed. So if it is 100KHz, then
delay is 10mcro second for 1 bit. We should wait for 2 bit (ack clock to be complete and
stop pulse to be transmitted).
This patch will make sure that i2c driver will not break the specs i.e. in case of NACK error, the stop
signal should be completed by i2c controller before resetting controller.
I will prefer of having the udelay(2*1000000/speed).

> 
> -Olof
