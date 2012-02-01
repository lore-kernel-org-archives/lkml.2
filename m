Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab2BARQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:16:39 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51223 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2BARQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:16:38 -0500
Message-ID: <1328116594.1882.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Module/kthread/printk question/problem
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 01 Feb 2012 18:16:34 +0100
In-Reply-To: <4F2969B7.4040202@linaro.org>
References: <4F2963AA.3010306@linaro.org>
	 <1328113899.1882.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4F2969B7.4040202@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 01 février 2012 à 20:35 +0400, Dmitry Antipov a écrit :
> On 02/01/2012 08:31 PM, Eric Dumazet wrote:
> 
> > Race is here :
> >
> > Here you allow testmod_exit() to continue, while _this_ thread has not
> > yet exited.
> >
> > And if this thread is preempted a litle bit, its code already was freed.
> > ->  crash.
> 
> I realize this, but there was a second part of the question: what's the
> better way to ensure that all test/X threads are really gone at some point of
> testmod_exit()?
> 

You could use kthread_stop() 

This way you can control all your kernel threads really exited before
module cleanup.




