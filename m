Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965350Ab2J3SZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:25:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43067 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760206Ab2J3SY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:24:57 -0400
Message-ID: <50901B72.6090201@ursulin.net>
Date: Tue, 30 Oct 2012 18:24:50 +0000
From: Tvrtko Ursulin <tvrtko@ursulin.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Milan Broz <mbroz@redhat.com>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-rt-users@vger.kernel.org, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org, okozina@redhat.com
Subject: Re: [PATCH] Fix crypto api init for 3.6.4-rt10
References: <5083C61C.5090807@gmail.com> <5083E4A8.3060501@ursulin.net> <5083E87B.2080908@gmail.com> <5083EC61.8070505@ursulin.net> <50844D01.9090805@gmail.com> <5084551E.5040304@ursulin.net> <508ED985.5060301@ursulin.net> <508EDD6E.7030908@gmail.com> <508EE395.9010709@ursulin.net> <508EEAF2.4090506@ursulin.net> <20121030094001.GV639@pengutronix.de> <508FA405.2050509@redhat.com> <508FF1D6.3030900@redhat.com>
In-Reply-To: <508FF1D6.3030900@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On 30/10/12 15:27, Milan Broz wrote:
> Fix crypto api for 3.6.4-rt10 (broken only in realtime patchset)
>
> In peterz-srcu-crypto-chain.patch the blocking notifier is changed
> to srcu notifier and added initialization to module init fucntion.
>
> Later, in crypto-make-core-static-and-init-scru-early.patch, is that
> initialization added also to core_initcall().
>
> This patch removes crypto_chain init from algapi initialization,
> because this function is called later and already initialized
> cryptomgr notifier is lost.
>
> This cause a failure in initialization of larval algorithms,
> like e.g. cbc(aes).

Thanks for the quick fix!

Tvrtko

