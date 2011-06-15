Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1FOIUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 04:20:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37231 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab1FOIUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 04:20:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=aeTDuiL7eAC99rfZGqUldxyXi5fRbXjPXnKt70Tvc94d0hh/bTw4ZJrum1g7OyYF8s
         Z6KY9f+pxu806bCc0c1fyZSDbhyVPeazAXyYoFafq2oO8QC0ze8eqbQwSyCSFN5iWAX4
         4X77Rp2VB26w6kCPrcT5O8Eej94ch2zOqQISE=
Date: Wed, 15 Jun 2011 10:18:58 +0200
From: Tejun Heo <tj@kernel.org>
To: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, "Girdwood, Liam" <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: Re: Re: Re: [PATCH v4 11/18] input: Add initial support for
 TWL6040 vibrator
Message-ID: <20110615081858.GM8141@htj.dyndns.org>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com>
 <4476185.bf2jyafmHt@barack>
 <20110614081836.GG8141@htj.dyndns.org>
 <100646074.zaKeYdXKr4@barack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <100646074.zaKeYdXKr4@barack>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 14, 2011 at 01:22:45PM +0300, Péter Ujfalusi wrote:
> However I did run a short experiments regarding to latencies:
> With create_singlethread_workqueue :
> Jun 14 12:54:30 omap-gentoo kernel: [  211.269531] vibra scheduling time: 30 usec
> Jun 14 12:54:30 omap-gentoo kernel: [  211.300811] vibra scheduling time: 30 usec
> Jun 14 12:54:33 omap-gentoo kernel: [  214.419006] vibra scheduling time: 31 usec
> Jun 14 12:54:34 omap-gentoo kernel: [  214.980987] vibra scheduling time: 30 usec
> Jun 14 12:54:35 omap-gentoo kernel: [  215.762115] vibra scheduling time: 30 usec
> Jun 14 12:54:35 omap-gentoo kernel: [  215.816650] vibra scheduling time: 30 usec
> Jun 14 12:54:35 omap-gentoo kernel: [  215.871337] vibra scheduling time: 61 usec
> Jun 14 12:54:35 omap-gentoo kernel: [  215.926025] vibra scheduling time: 61 usec
> Jun 14 12:54:35 omap-gentoo kernel: [  215.980743] vibra scheduling time: 61 usec
> Jun 14 12:54:35 omap-gentoo kernel: [  216.035430] vibra scheduling time: 61 usec
> Jun 14 12:54:38 omap-gentoo kernel: [  219.425659] vibra scheduling time: 31 usec
> Jun 14 12:54:40 omap-gentoo kernel: [  220.981658] vibra scheduling time: 31 usec
> Jun 14 12:54:44 omap-gentoo kernel: [  224.692504] vibra scheduling time: 30 usec
> Jun 14 12:54:44 omap-gentoo kernel: [  225.067138] vibra scheduling time: 30 usec
> 
> With create_workqueue :
> Jun 14 12:05:00 omap-gentoo kernel: [  304.965393] vibra scheduling time: 183 usec
> Jun 14 12:05:01 omap-gentoo kernel: [  305.964996] vibra scheduling time: 61 usec
> Jun 14 12:05:03 omap-gentoo kernel: [  307.684082] vibra scheduling time: 152 usec
> Jun 14 12:05:06 omap-gentoo kernel: [  310.972778] vibra scheduling time: 30 usec
> Jun 14 12:05:08 omap-gentoo kernel: [  312.683715] vibra scheduling time: 61 usec
> Jun 14 12:05:10 omap-gentoo kernel: [  314.785675] vibra scheduling time: 183 usec
> Jun 14 12:05:15 omap-gentoo kernel: [  319.800903] vibra scheduling time: 61 usec
> Jun 14 12:05:16 omap-gentoo kernel: [  320.738403] vibra scheduling time: 30 usec
> Jun 14 12:05:16 omap-gentoo kernel: [  320.793090] vibra scheduling time: 61 usec
> Jun 14 12:05:16 omap-gentoo kernel: [  320.847778] vibra scheduling time: 61 usec
> Jun 14 12:05:16 omap-gentoo kernel: [  320.902465] vibra scheduling time: 61 usec
> Jun 14 12:05:16 omap-gentoo kernel: [  320.957153] vibra scheduling time: 61 usec
> Jun 14 12:05:16 omap-gentoo kernel: [  320.996185] vibra scheduling time: 31 usec
> 
> This is in a system, where I do not have any other drivers on I2C bus, and I have
> generated some load with this command:
> grep -r generate_load /*
> 
> So, I have some CPU, and IO load as well.
> 
> At the end the differences are not that big, but with create_singlethread_workqueue
> I can see less spikes.
> 
> This is with 3.0-rc2 kernel
> 
> I still think, that there is a place for the create_singlethread_workqueue, and the
> tactile feedback needs such a thing.

So, yes, WQ_HIGHPRI would make difference in latency but as can be
seen above in usecs range not msecs range and you're trading off batch
execution and processing locality for it.

> As I recall correctly this was the reason to use create_singlethread_workqueue
> in the twl4030-vibra driver as well (there were latency issues without it).

Before cmwq, the latency which can be induced by using system
workqueue can be easily upto seconds range.  With cmwq, it should be
in the usecs to few millisecs range.  If that's not enough, the use
case probably calls for dedicated RT thread or threaded IRQ handler.

No human being can feel 120usec difference and I can't see how using
HIGHPRI is justified here (which is what the code is doing
_accidentally_ by using singlethread_workqueue).

Thank you.

-- 
tejun
