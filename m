Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2B0Fk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 00:40:27 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57768 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2B0Fk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 00:40:26 -0500
Message-ID: <1330321223.3330.1.camel@edumazet-laptop>
Subject: Re: RFC: memory leak in udp_table_init
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: paul.gortmaker@windriver.com, tim.bird@am.sony.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 27 Feb 2012 06:40:23 +0100
In-Reply-To: <20120226.142038.556939530554716833.davem@davemloft.net>
References: <4F48318E.8070902@am.sony.com>
	 <CAP=VYLp7+Apubm=PHRLSw50V9zBKmV-xFRvcO4-qAogJVp7jcw@mail.gmail.com>
	 <1330147182.2462.25.camel@edumazet-laptop>
	 <20120226.142038.556939530554716833.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 26 février 2012 à 14:20 -0500, David Miller a écrit :
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Sat, 25 Feb 2012 06:19:42 +0100
> 
> > [PATCH] mm: add a low limit to alloc_large_system_hash
> 
> I think you should just use zero as the default minimum for all
> call sites except this UDP case we are trying to fix.
> 
> For example I see you used 16 for kernel/pid.c
> 
> Let's not try to do unrelated changes like that now, we can do such
> tweaks later.

It was to match the comment we have few lines above :

/*
 * The pid hash table is scaled according to the amount of memory in the
 * machine.  From a minimum of 16 slots up to 4096 slots at one gigabyte or
 * more.
 */


