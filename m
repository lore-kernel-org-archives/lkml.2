Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321Ab0I0Wxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:53:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35351
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752Ab0I0Wxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:53:54 -0400
Date: Mon, 27 Sep 2010 15:54:14 -0700 (PDT)
Message-Id: <20100927.155414.43043854.davem@davemloft.net>
To: sven.eckelmann@gmx.de
Cc: ericvh@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: Mount only matching virtio channels
From: David Miller <davem@davemloft.net>
In-Reply-To: <1285514893-11233-1-git-send-email-sven.eckelmann@gmx.de>
References: <1285514893-11233-1-git-send-email-sven.eckelmann@gmx.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven Eckelmann <sven.eckelmann@gmx.de>
Date: Sun, 26 Sep 2010 17:28:13 +0200

> p9_virtio_create will only compare the the channel's tag characters
> against the device name till the end of the channel's tag but not till
> the end of the device name. This means that if a user defines channels
> with the tags foo and foobar then he would mount foo when he requested
> foonot and may mount foo when he requested foobar.
> 
> Thus it is necessary to check both string lengths against each other in
> case of a successful partial string match.
> 
> Signed-off-by: Sven Eckelmann <sven.eckelmann@gmx.de>

I'll apply this, but this code would be so much simpler and this bug
would have never happened if these tags were NULL terminated when they
were pulled in from virtio.
