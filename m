Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab2HOPCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:02:40 -0400
Received: from mail.vyatta.com ([76.74.103.46]:40458 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479Ab2HOPCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:02:38 -0400
Date: Wed, 15 Aug 2012 08:02:26 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Ren, Cloud" <cjren@qca.qualcomm.com>
Cc: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Huang, Xiong" <xiong@qca.qualcomm.com>,
        "hao-ran.liu@canonical.com" <hao-ran.liu@canonical.com>,
        "joe@perches.com" <joe@perches.com>,
        "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH] net: add new QCA alx ethernet driver
Message-ID: <20120815080226.388ea856@nehalam.linuxnetplumber.net>
In-Reply-To: <6349D7A510622448B1BA0967850A84380136A218@NASANEXD02D.na.qualcomm.com>
References: <1344507270-2907-1-git-send-email-cjren@qca.qualcomm.com>
	<20120811135044.529a7081@nehalam.linuxnetplumber.net>
	<6349D7A510622448B1BA0967850A84380136A1EF@NASANEXD02D.na.qualcomm.com>
	<20120814.223258.1180104882398843954.davem@davemloft.net>
	<6349D7A510622448B1BA0967850A84380136A218@NASANEXD02D.na.qualcomm.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012 05:39:11 +0000
"Ren, Cloud" <cjren@qca.qualcomm.com> wrote:

> From: David Miller [mailto:davem@davemloft.net]
> Sent: Wednesday, August 15, 2012 1:33 PM
> 
> >From: "Ren, Cloud" <cjren@qca.qualcomm.com>
> >Date: Wed, 15 Aug 2012 03:29:26 +0000
> >
> >>>> +	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
> >>>> ...
> >>>> +	strcpy(netdev->name, "eth%d");
> >>>> +	retval = register_netdev(netdev);
> >>>
> >>>The strcpy is unnecessary, alloc_etherdev already sets that.
> >>
> >> The strcpy is useful. netdev->name is set as pci_name in front. So the strcpy
> >restores it.
> >
> >Are you doing this just to influence the initial driver log messages?
> 
>  Yes.
> 
> >
> >Don't do that, it's gross.
> 
> Ok, I will remove it.

Before the driver is registered, use dev_info() type of logging.
