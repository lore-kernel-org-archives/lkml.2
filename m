Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2CaV1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:27:15 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36580 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2CaV1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:27:13 -0400
Date: Sat, 31 Mar 2012 17:27:10 -0400 (EDT)
Message-Id: <20120331.172710.540592519617177028.davem@davemloft.net>
To: drepper@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sendmmsg: put_user vs __put_user
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAOPLpQewA-AduBudgH5FK6Kz_=nHv6eFhGD29TkAosPTdP4ZHg@mail.gmail.com>
References: <CAOPLpQf2bmj+i_zYtsS8JNzTDuBxCO5ByNRRqwv0kxaDBFdezg@mail.gmail.com>
	<20120330.205120.2221145622131588797.davem@davemloft.net>
	<CAOPLpQewA-AduBudgH5FK6Kz_=nHv6eFhGD29TkAosPTdP4ZHg@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 31 Mar 2012 14:27:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@gmail.com>
Date: Sat, 31 Mar 2012 08:30:25 -0400

> On Fri, Mar 30, 2012 at 20:51, David Miller <davem@davemloft.net> wrote:
>> Compat processes are not able to generate virtual addresses anywhere
>> near the range where the kernel resides, so the address range
>> verification done by put_user() is completely superfluous and
>> therefore not necessary.  The normal exception handling done by the
>> access is completely sufficient.
> 
> I was more thinking about the effects of might_fault() then additional tests.

This is very clearly in a context where locks are not held and sleeping
would be fine, so I don't see any value in that either.
