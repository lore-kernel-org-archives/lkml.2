Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab0HXVqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 17:46:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53375
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755718Ab0HXVqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 17:46:08 -0400
Date: Tue, 24 Aug 2010 14:46:26 -0700 (PDT)
Message-Id: <20100824.144626.260108998.davem@davemloft.net>
To: avorontsov@mvista.com
Cc: afleming@freescale.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phylib: Fix race between returning phydev and calling
 adjust_link
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100824193412.GA1887@oksana.dev.rtsoft.ru>
References: <20100824193412.GA1887@oksana.dev.rtsoft.ru>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <avorontsov@mvista.com>
Date: Tue, 24 Aug 2010 23:34:12 +0400

> It is possible that phylib will call adjust_link before returning
> from {,of_}phy_connect(), which may cause the following [very rare,
> though] oops upon reopening the device:
 ...
> To fix the issue, simply initialize the PHY's state to PHY_READY during
> phy_attach(). This will ensure that phylib won't call adjust_link before
> phy_start().
> 
> Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>

Applied, thanks Anton.
