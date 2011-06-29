Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab1F2Unr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:43:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63722 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757714Ab1F2Unn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:43:43 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=yGV206oZUtoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=TApWS8Kj85K4CGVL43AA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] plist: add mutex to the blessed lock type for plists
From: Steven Rostedt <rostedt@goodmis.org>
To: Dima Zavin <dima@android.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <CAPz4a6CbzEm3QJZ-5wsaiSH1H9g7tgo7E7-HyRB8Fv5=NfGDRQ@mail.gmail.com>
References: <1309376033-32005-1-git-send-email-dima@android.com>
	 <m2tyb81jml.fsf@firstfloor.org>
	 <CAPz4a6CbzEm3QJZ-5wsaiSH1H9g7tgo7E7-HyRB8Fv5=NfGDRQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 29 Jun 2011 16:43:41 -0400
Message-ID: <1309380221.26417.50.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 13:34 -0700, Dima Zavin wrote:

> The whole enforcement of locking inside this code is awkward anyway.
> We don't enforce locking on rb_trees, or on list_head, etc. Why
> plists? The funny part is that the test code in plist.c itself has a
> hack to skip the lock check.

It's a legacy from the -rt tree. With the development there, there was
always a case where a plist was added without the proper locking, and we
spent days debugging it. This test proved very useful. As plists came to
mainline, we kept the tests.

Now, getting rid of them maybe the thing to do. I'm not sure how useful
they are today.

-- Steve


