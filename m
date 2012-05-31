Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab2EaH4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:56:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40714 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab2EaH4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:56:30 -0400
Subject: Re: NOHZ: local_softirq_pending 08
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.02.1205310938080.3231@ionos>
References: <20120530214809.GA19223@redhat.com>
	 <alpine.LFD.2.02.1205310938080.3231@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 May 2012 09:56:25 +0200
Message-ID: <1338450985.2760.1270.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 09:52 +0200, Thomas Gleixner wrote:
> Dave,
> 
> On Wed, 30 May 2012, Dave Jones wrote:
> 
> > May 30 17:43:04 [ 1095.335659] NOHZ: local_softirq_pending 08
> > 
> > According to git, you ratelimited this back in 2007 with the message
> > "until we found the root cause of that problem."
> > 
> > Is this an old problem that has returned ?
> 
> Looks like.
>  
> > Maybe interesting note: Both machines I see this on regularly are Atom cpus,
> > and it's always '08'.
> 
> So it goes idle with NET_RX softirq pending. That really should not
> happen. I fear you need to fire up the tracer :)

It might be a bug in the network driver, a race with NAPI completion.

Dave, which net drivers run on these machines ?


