Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab2GIBdk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 21:33:40 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:60868 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2GIBdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 21:33:39 -0400
Message-ID: <1341797610.2439.3.camel@ThinkPad-T420>
Subject: Re: [PATCH] Fix a dead loop in async_synchronize_full()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, arjan@linux.intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 09 Jul 2012 09:33:30 +0800
In-Reply-To: <CAM_iQpXhgqOQcD1s9O2weQv8xqfZ6Jpc4atR+QSosrYocbCK-Q@mail.gmail.com>
References: <1341209044.5102.20.camel@ThinkPad-T420>
	 <CAM_iQpXhgqOQcD1s9O2weQv8xqfZ6Jpc4atR+QSosrYocbCK-Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12070901-9574-0000-0000-0000037DAA16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 17:12 +0800, Cong Wang wrote:
> On Mon, Jul 2, 2012 at 2:04 PM, Li Zhong <zhong@linux.vnet.ibm.com> wrote:
> >  void async_synchronize_full(void)
> >  {
> > -       do {
> > -               async_synchronize_cookie(next_cookie);
> > -       } while (!list_empty(&async_running) || !list_empty(&async_pending));
> > +       async_synchronize_cookie_domain(next_cookie, NULL);
> >  }
> 
> A nitpick:
> 
>  async_synchronize_cookie_domain(next_cookie, NULL);
> 
> equals to
> 
>  async_synchronize_full_domain(NULL)
> 

Why do we need one more level in the function calling stack? 

