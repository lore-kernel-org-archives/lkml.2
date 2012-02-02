Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab2BBJ6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:58:25 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44420 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2BBJ6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:58:22 -0500
Message-ID: <1328176698.2279.8.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Module/kthread/printk question/problem
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 02 Feb 2012 10:58:18 +0100
In-Reply-To: <4F2A55E0.3040404@linaro.org>
References: <4F2963AA.3010306@linaro.org>
	   <1328113899.1882.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	   <4F2969B7.4040202@linaro.org>
	  <1328116594.1882.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	  <4F2A296E.5080007@linaro.org>
	 <1328174158.2279.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4F2A55E0.3040404@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 02 février 2012 à 13:22 +0400, Dmitry Antipov a écrit :
> On 02/02/2012 01:15 PM, Eric Dumazet wrote:
> 
> >
> > Try following code :
> >
> 
> I already did it myself (except redundant wake_up_process(), which
> is performed by kthread_run() anyway).

Then its racy, unless you also changed the way your worker threads exit.

By the time kthread_run() returns, child thread can already be gone.

This is why I use kthread_create() : to be able to get_task_struct() so
that task_struct cannot disappear, even if the child exits really fast :

int worker(void *arg)
{
	return 0;
}


