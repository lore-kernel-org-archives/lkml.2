Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2CLGsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 02:48:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44395 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2CLGsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 02:48:31 -0400
Date: Sun, 11 Mar 2012 23:48:08 -0700 (PDT)
Message-Id: <20120311.234808.1919218898572322534.davem@davemloft.net>
To: santoshprasadnayak@gmail.com
Cc: sony.chacko@qlogic.com, rajesh.borundia@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/3 v2] netxen: qlogic ethernet : Fix endian bug.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331534303-4093-1-git-send-email-santoshprasadnayak@gmail.com>
References: <1331534303-4093-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 11 Mar 2012 23:48:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: santosh nayak <santoshprasadnayak@gmail.com>
Date: Mon, 12 Mar 2012 12:08:23 +0530

> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> Fix endian bug.
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>

This is a very non-trivial patch, therefore the terse commit
message and the lack of any comments in this code is unacceptable.

This commit message is not only terse, it's wrong.  You're not
fixing an endian bug, you're fixing several of them.

Explain everything in your commit message.

>  	req.words[0] = cpu_to_le64(cmd);
> -	req.words[1] = cpu_to_le64(ip);
> +	memcpy(&req.words[1], &ip, sizeof(u32));

Nobody is going to read that and have any idea why it's correct unless
they happen to be able to discover the long thread you guys had this
past week working out how to do this change correctly.

Putting a comment here for the rest of us mere mortals is therefore
absolutely required.
