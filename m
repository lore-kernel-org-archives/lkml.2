Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223Ab2FUU14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:27:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34345 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab2FUU1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:27:55 -0400
Subject: Re: Bug in net/ipv6/ip6_fib.c:fib6_dump_table()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Josh Hunt <johunt@akamai.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "kaber@trash.net" <kaber@trash.net>,
        Debabrata Banerjee <dbavatar@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "pekkas@netcore.fi" <pekkas@netcore.fi>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4FE37783.9000409@akamai.com>
References: <CAATkVEzTxT6d5nzt_qwCuFWM-WcN8hdhjGxFRPXJ4=L35wKbGw@mail.gmail.com>
	 <4FE37783.9000409@akamai.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jun 2012 22:27:49 +0200
Message-ID: <1340310469.4604.6702.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 14:35 -0500, Josh Hunt wrote:

> Can anyone provide details of the crash which was intended to be fixed
> by 2bec5a369ee79576a3eea2c23863325089785a2c? With this patch in and
> doing concurrent adds/deletes and dumping the table via netlink causes
> duplicate entries to be reported. Reverting this patch causes those
> problems to go away. We can provide a more detailed test if that is
> needed, but so far our testing has been unable to reproduce the crash
> mentioned in the above commit with it reverted.

A mere revert wont be enough.

Looking at this code, it lacks proper synchronization
between tree updaters and tree walkers.

fib6_walker_lock rwlock is not enough to prevent races.

Are you willing to fix this yourself ?



