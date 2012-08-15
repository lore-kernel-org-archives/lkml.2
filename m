Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab2HOFdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 01:33:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42738 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab2HOFdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 01:33:01 -0400
Date: Tue, 14 Aug 2012 22:32:58 -0700 (PDT)
Message-Id: <20120814.223258.1180104882398843954.davem@davemloft.net>
To: cjren@qca.qualcomm.com
Cc: shemminger@vyatta.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qca-linux-team@qualcomm.com,
        nic-devel@qualcomm.com, xiong@qca.qualcomm.com,
        hao-ran.liu@canonical.com, joe@perches.com, rodrigue@qca.qualcomm.com
Subject: Re: [PATCH] net: add new QCA alx ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <6349D7A510622448B1BA0967850A84380136A1EF@NASANEXD02D.na.qualcomm.com>
References: <1344507270-2907-1-git-send-email-cjren@qca.qualcomm.com>
	<20120811135044.529a7081@nehalam.linuxnetplumber.net>
	<6349D7A510622448B1BA0967850A84380136A1EF@NASANEXD02D.na.qualcomm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ren, Cloud" <cjren@qca.qualcomm.com>
Date: Wed, 15 Aug 2012 03:29:26 +0000

>>> +	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
>>> ...
>>> +	strcpy(netdev->name, "eth%d");
>>> +	retval = register_netdev(netdev);
>>
>>The strcpy is unnecessary, alloc_etherdev already sets that.
> 
> The strcpy is useful. netdev->name is set as pci_name in front. So the strcpy restores it.

Are you doing this just to influence the initial driver log messages?

Don't do that, it's gross.
