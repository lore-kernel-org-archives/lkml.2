Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2JZFpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 01:45:40 -0400
Received: from www84.your-server.de ([213.133.104.84]:60649 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab2JZFpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 01:45:38 -0400
Message-ID: <1351230291.12511.7.camel@wall-e>
Subject: Re: linux-next: build warnings after merge of the akpm tree
From: Stefani Seibold <stefani@seibold.net>
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Date: Fri, 26 Oct 2012 07:44:51 +0200
In-Reply-To: <20121025223656.GA3805@richard.(null)>
References: <20121025142854.1924363d6a607004f918ac63@canb.auug.org.au>
	 <20121025143044.d21e2c29b16ee2005f93a371@canb.auug.org.au>
	 <508948de.01dc440a.58ed.ffffff17SMTPIN_ADDED@mx.google.com>
	 <20121025152337.7f14919d.akpm@linux-foundation.org>
	 <20121025223656.GA3805@richard.(null)>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 26.10.2012, 06:36 +0800 schrieb Richard Yang:

> >
> >And holy cow that code is hard to read :( Why was kfifo_in()
> >implemented as a macro, anyway?  AFAICT all its args have a known type,
> >so we could have used a proper C interface, which would have fixed all
> >this nicely.
> 

Thats simple for performance reasons, the compiler remove most of the
code during the compile stage, so no runtime checks are necessary. And
it is the only way since C does not provides templates like C++.
 
> Hmm, move the definition of kfifo_in()/kfifo_out() into the kfifo.c?
> 

Don't do it. this will result in a performance degradation. Look at the
disassembled code by each change in code and compare it with the
previous one. I don't believe that you can produce better code.

