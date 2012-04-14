Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab2DNOW7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 10:22:59 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:55813 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752059Ab2DNOW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 10:22:58 -0400
Message-ID: <1334413369.7150.422.camel@deadeye>
Subject: RE: [PATCH 04/37] atl1c: remove VPD register
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Huang, Xiong" <xiong@qca.qualcomm.com>
CC: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>
Date: Sat, 14 Apr 2012 15:22:49 +0100
In-Reply-To: <157393863283F442885425D2C454285623D486D9@nasanexd02a.na.qualcomm.com>
References: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
	 <1334276102-15866-5-git-send-email-xiong@qca.qualcomm.com>
	 <20120413.204551.959091962456153270.davem@davemloft.net>
	 <157393863283F442885425D2C454285623D486D9@nasanexd02a.na.qualcomm.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18836.005
X-TM-AS-Result: No--29.101700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-14 at 09:12 +0000, Huang, Xiong wrote:
> 
> > -----Original Message-----
> > From: David Miller [mailto:davem@davemloft.net]
> > Sent: Saturday, April 14, 2012 8:46
> > To: Huang, Xiong
> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; qca-linux-team; nic-
> > devel
> > Subject: Re: [PATCH 04/37] atl1c: remove VPD register
> > 
> > From: xiong <xiong@qca.qualcomm.com>
> > Date: Fri, 13 Apr 2012 08:14:29 +0800
> > 
> > > VPD register is only used for L1(devid=PCI_DEVICE_ID_ATTANSIC_L1) to
> > > access external NV-memory.
> > > l1c & later chip doesn't use it any more.
> > >
> > > Signed-off-by: xiong <xiong@qca.qualcomm.com>
> > > Tested-by: Liu David <dwliu@qca.qualcomm.com>
> > 
> > You just broke ethtool register dumps with this change.
> > 
> > Now, all the initial registers are reported offset by one entry, yet the last two are
> > still reported in their original spots.
> > 
> > This layout is exposed to userspace, and interpreted by tools, and you cannot
> > change it.
> > 
> > If this register always reports some value, you should just keep it there in the
> > dumps.
> >
> The VPD register doesn't report anything :(, just a dummy register now.
> we don't have any special tools in userspace to explain the dumped registers.
> Actually the purpose of dumping these registers via ethtool is just for debug.
[...]

Of course, the whole purpose of the operation is for debugging.  But you
should bump the dump version number (currently 0) every time you change
the offsets of registers in the dump.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

