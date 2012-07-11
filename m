Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab2GKQsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 12:48:16 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36499 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958Ab2GKQsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 12:48:13 -0400
Message-ID: <4FFDAE1D.3050008@us.ibm.com>
Date: Wed, 11 Jul 2012 09:47:25 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/6] hrtimer: Provide clock_was_set_delayed()
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com> <1341960205-56738-2-git-send-email-johnstul@us.ibm.com> <4FFD6E5A.9060206@redhat.com> <alpine.LFD.2.02.1207111425260.32033@ionos> <1342011904.3462.152.camel@twins> <alpine.LFD.2.02.1207111539060.32033@ionos>
In-Reply-To: <alpine.LFD.2.02.1207111539060.32033@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071116-4242-0000-0000-00000249BAE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 08:18 AM, Thomas Gleixner wrote:
> That leaves NOHZ enabled systems and there we might be clever and
> avoid the IPIs to those cores which are not idle and let the tick
> interrupt deal with it. And we can make the calls async and just let
> them raise the hrtimer softirq on those cores, which will run the
> hrtimer interrupt code and take care of everything.

I'm not familiar with the details of the code that tracks which cores 
are idle or not, but I'd worry with this approach that there might be 
further races in determining which cores are idle and which cores are 
about to go idle with stale base offsets.

I'll see if my worry is unfounded, but it might be a bit too clever for 
rare events.

thanks
-john

