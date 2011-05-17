Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab1EQVzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 17:55:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43205 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1EQVzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 17:55:09 -0400
Subject: Re: [PATCH 1/3] comm: Introduce comm_lock spinlock to protect
 task->comm access
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>, Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <20110517212734.GB28054@elte.hu>
References: <1305665263-20933-1-git-send-email-john.stultz@linaro.org>
	 <1305665263-20933-2-git-send-email-john.stultz@linaro.org>
	 <20110517212734.GB28054@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 17 May 2011 23:54:16 +0200
Message-ID: <1305669256.2466.6286.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 23:27 +0200, Ingo Molnar wrote:
> * John Stultz <john.stultz@linaro.org> wrote:
> 
> > The implicit rules for current->comm access being safe without locking are no 
> > longer true. Accessing current->comm without holding the task lock may result 
> > in null or incomplete strings (however, access won't run off the end of the 
> > string).
> 
> This is rather unfortunate - task->comm is used in a number of performance 
> critical codepaths such as tracing.
> 
> Why does this matter so much? A NULL string is not a big deal.
> 
> Note, since task->comm is 16 bytes there's the CMPXCHG16B instruction on x86 
> which could be used to update it atomically, should atomicity really be 
> desired.

The changelog also fails to mention _WHY_ this is no longer true. Nor
does it treat why making it true again isn't an option.

Who is changing another task's comm? That's just silly.
