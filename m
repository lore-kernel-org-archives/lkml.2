Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab2ARCnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 21:43:21 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36294 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756538Ab2ARCnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 21:43:20 -0500
Message-ID: <1326854599.20922.19.camel@joe2Laptop>
Subject: Re: [PATCH] vsprintf: Prevent NULL dereference using %pNF
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Date: Tue, 17 Jan 2012 18:43:19 -0800
In-Reply-To: <20120117211215.GA18268@rere.qmqm.pl>
References: <1326825433.17202.6.camel@joe2Laptop>
	 <20120117.134640.1673981737109339596.davem@davemloft.net>
	 <1326826273.17202.11.camel@joe2Laptop>
	 <20120117193910.GA17092@rere.qmqm.pl>
	 <1326829420.17202.21.camel@joe2Laptop>
	 <20120117211215.GA18268@rere.qmqm.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 22:12 +0100, Michał Mirosław wrote:
> On Tue, Jan 17, 2012 at 11:43:40AM -0800, Joe Perches wrote:
> > Isn't an additional copy of "struct printf_spec spec" on the stack
> > in function pointer() now?
> If the function is inlined then gcc should know that original is not needed
> after call and do no copy. Without inlining, gcc should too, optimize it
> because it's a tail call.
> We could read the generated assembly to be sure, of course.

At least for x86/gcc 4.6, it seems it doesn't make any difference.


