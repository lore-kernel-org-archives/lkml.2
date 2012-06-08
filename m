Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762161Ab2FHQqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:46:31 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45832 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2FHQqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:46:30 -0400
Message-ID: <4FD22C60.4030903@gmail.com>
Date: Fri, 08 Jun 2012 19:46:24 +0300
From: Nikos Chantziaras <realnc@gmail.com>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120607 Thunderbird/13.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
References: <20120530214809.GA19223@redhat.com> <alpine.LFD.2.02.1205310938080.3231@ionos> <1338450985.2760.1270.camel@edumazet-glaptop> <20120531140432.GC1749@redhat.com>
In-Reply-To: <20120531140432.GC1749@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/12 17:04, Dave Jones wrote:
> On Thu, May 31, 2012 at 09:56:25AM +0200, Eric Dumazet wrote:
>   > On Thu, 2012-05-31 at 09:52 +0200, Thomas Gleixner wrote:
>   > > Dave,
>   > >
>   > > On Wed, 30 May 2012, Dave Jones wrote:
>   > >
>   > > > May 30 17:43:04 [ 1095.335659] NOHZ: local_softirq_pending 08
>   > > >
>   > > > According to git, you ratelimited this back in 2007 with the message
>   > > > "until we found the root cause of that problem."
>   > > >
>   > > > Is this an old problem that has returned ?
>   > >
>   > > Looks like.
>   > >
>   > > > Maybe interesting note: Both machines I see this on regularly are Atom cpus,
>   > > > and it's always '08'.
>   > >
>   > > So it goes idle with NET_RX softirq pending. That really should not
>   > > happen. I fear you need to fire up the tracer :)
>   >
>   > It might be a bug in the network driver, a race with NAPI completion.
>   >
>   > Dave, which net drivers run on these machines ?
>
> r8169.
>
> I got an email from someone else asking if I used Realtek drivers, which I thought
> was an uncanny guess.

Same thing happens here (kernel 3.4.1, also happened with 3.4.0):

r8169 0000:06:00.0: eth0: link down
r8169 0000:06:00.0: eth0: link down
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
r8169 0000:06:00.0: eth0: link up
