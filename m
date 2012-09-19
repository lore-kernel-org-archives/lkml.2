Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2ISXSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 19:18:11 -0400
Received: from mail.vyatta.com ([76.74.103.46]:45053 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab2ISXSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 19:18:09 -0400
Date: Wed, 19 Sep 2012 16:04:38 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, davem@davemloft.net, mlindner@marvell.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch net] sky2: fix rx filter setup on link up
Message-ID: <20120919160438.52ed0b1a@s6510.linuxnetplumber.net>
In-Reply-To: <20120919203825.GA1460@minipsycho.orion>
References: <1347894617-13614-1-git-send-email-jiri@resnulli.us>
	<20120919132248.5fced1c7@s6510.linuxnetplumber.net>
	<20120919203825.GA1460@minipsycho.orion>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2012 22:38:25 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> You cannot call sky2_set_multicast() directly here. It is called from
> __dev_set_rx_mode(). You would have to take at lease netif_addr_lock()
> here. I think that clearer is to remember computed value....

Ugh, it would mean changing link_up to being done via workqueue.
But your code wasnt safe against changes to values from set_multicast race
either.

