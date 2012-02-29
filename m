Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030707Ab2B2Dcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 22:32:41 -0500
Received: from mail.vyatta.com ([76.74.103.46]:42994 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965021Ab2B2Dck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 22:32:40 -0500
Date: Tue, 28 Feb 2012 19:32:37 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mcgrof@frijolero.org>,
        <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        <kgiori@qca.qualcomm.com>, <chris.snook@gmail.com>,
        <mathieu@qca.qualcomm.com>, <bryanh@quicinc.com>
Subject: Re: [PATCH] net: add QCA alx Ethernet driver
Message-ID: <20120228193237.2d56f2b8@nehalam.linuxnetplumber.net>
In-Reply-To: <1330480210-30470-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330480210-30470-1-git-send-email-rodrigue@qca.qualcomm.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 17:50:09 -0800
"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com> wrote:

> From: Luis R. Rodriguez <mcgrof@frijolero.org>
> 
> The next patch adds the new QCA alx Ethernet driver that
> supercedes the atl1c Ethernet driver. For details please
> read the commit log of the patch. Given the size you can
> download the patch from:
> 
> http://bombadil.infradead.org/~mcgrof/2012/02/28/add-alx-next-20120228.patch
> sha1sum: 8a8f7b6f1cbe737e70ec3b3eda483a6925fd9bd6

Evolution is better. The new driver has lots of new callbacks to handle
the fact it is dealing with two different chipsets. Not only that your callbacks
are built at runtime which leads to security concerns.

There is a reason the two Marvell based drivers (skge and sky2) are
different drivers. Having to do extra per-chip callbacks is a clear sign
the driver should be split in two.
