Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab2GFJMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:12:38 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33223 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab2GFJMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <1341209044.5102.20.camel@ThinkPad-T420>
References: <1341209044.5102.20.camel@ThinkPad-T420>
Date: Fri, 6 Jul 2012 17:12:35 +0800
Message-ID: <CAM_iQpXhgqOQcD1s9O2weQv8xqfZ6Jpc4atR+QSosrYocbCK-Q@mail.gmail.com>
Subject: Re: [PATCH] Fix a dead loop in async_synchronize_full()
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, arjan@linux.intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 2:04 PM, Li Zhong <zhong@linux.vnet.ibm.com> wrote:
>  void async_synchronize_full(void)
>  {
> -       do {
> -               async_synchronize_cookie(next_cookie);
> -       } while (!list_empty(&async_running) || !list_empty(&async_pending));
> +       async_synchronize_cookie_domain(next_cookie, NULL);
>  }

A nitpick:

 async_synchronize_cookie_domain(next_cookie, NULL);

equals to

 async_synchronize_full_domain(NULL)
