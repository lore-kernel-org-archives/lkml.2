Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab0HOHBc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 03:01:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58395
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932094Ab0HOHBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 03:01:31 -0400
Date: Sun, 15 Aug 2010 00:01:48 -0700 (PDT)
Message-Id: <20100815.000148.68144298.davem@davemloft.net>
To: weil@mail.berlios.de
Cc: linux-kernel@vger.kernel.org, avorontsov@ru.mvista.com,
        ben@decadent.org.uk, jgunthorpe@obsidianresearch.com
Subject: Re: [PATCH] phy: Add missing forward declaration (fixes compiler
 warning)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1280855041-4063-1-git-send-email-weil@mail.berlios.de>
References: <1280855041-4063-1-git-send-email-weil@mail.berlios.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Weil <weil@mail.berlios.de>
Date: Tue,  3 Aug 2010 19:04:01 +0200

> Without forward declaration for struct sk_buff, compilation
> of drivers/net/phy/fixed.c results in a warning:

linux/phy.h has had the appropriate forward declaration since
July 16th

In fact the forward declaration was added by the only patch
that added references to sk_buff in that header file:

--------------------
commit c1f19b51d1d87f3e3bb7e6648f43f7d57ed2da6b
Author: Richard Cochran <richardcochran@gmail.com>
Date:   Sat Jul 17 08:49:36 2010 +0000

    net: support time stamping in phy devices.
    
 ...
--------------------

As per your warning:

--------------------
  CC      drivers/net/phy/fixed.o
In file included from drivers/net/phy/fixed.c:20:
include/linux/phy.h:342: warning: 'struct sk_buff' declared inside parameter list
include/linux/phy.h:342: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/phy.h:343: warning: 'struct sk_buff' declared inside parameter list

(tested with linux kernel for openwrt / ar7, gcc-4.1.2)
--------------------

Line 342 in the current tree lands on a comment.  Please don't
post patches against external trees, or you'll always run into
problems like this.  Who knows what patches happen to be applied
to the openwrt tree you happen to have.

Always spin and test patches against upstream.

