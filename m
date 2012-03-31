Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab2CaAv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 20:51:27 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57662 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2CaAvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 20:51:25 -0400
Date: Fri, 30 Mar 2012 20:51:20 -0400 (EDT)
Message-Id: <20120330.205120.2221145622131588797.davem@davemloft.net>
To: drepper@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sendmmsg: put_user vs __put_user
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAOPLpQf2bmj+i_zYtsS8JNzTDuBxCO5ByNRRqwv0kxaDBFdezg@mail.gmail.com>
References: <CAOPLpQf2bmj+i_zYtsS8JNzTDuBxCO5ByNRRqwv0kxaDBFdezg@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 30 Mar 2012 17:51:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@gmail.com>
Date: Fri, 30 Mar 2012 09:36:11 -0400

> Shouldn't the compat code in the sendmmsg implementation use the same
> code as the normal code?  In which case you probably want something
> like this:

Compat processes are not able to generate virtual addresses anywhere
near the range where the kernel resides, so the address range
verification done by put_user() is completely superfluous and
therefore not necessary.  The normal exception handling done by the
access is completely sufficient.
