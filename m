Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab2BSXy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 18:54:26 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40592 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2BSXyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 18:54:25 -0500
Date: Sun, 19 Feb 2012 18:54:20 -0500 (EST)
Message-Id: <20120219.185420.1710587455826987655.davem@davemloft.net>
To: pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] 8139cp: reject invalid MTU values
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329481995-28384-1-git-send-email-pbonzini@redhat.com>
References: <1329481995-28384-1-git-send-email-pbonzini@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 19 Feb 2012 15:54:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 17 Feb 2012 13:33:15 +0100

> The 8139cp driver has a change_mtu function that has not been
> enabled since the dawn of the git repository.  However, the
> generic eth_change_mtu is not used in its place, so that
> invalid MTU values can be set on the interface.
> 
> This patch salvages the broken code for the single case of
> setting the MTU while the interface is down, which is safe
> and also includes the range check.

Well, now you can't change the MTU while the device is up
which to me is a worse problem than MTU validation because
this breaks valid things that potentially worked previously.

Also you didn't bother to give your patch a proper signoff.

You're going to have to fix cp_change_mtu() so that it does the
correct HW reset sequence when the MTU changes, otherwise I am not
going to apply this patch.
