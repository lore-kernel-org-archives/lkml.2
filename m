Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab1JXLbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 07:31:14 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38649 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab1JXLbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 07:31:13 -0400
Date: Mon, 24 Oct 2011 19:30:56 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [RFC] [PATCH -rt 5/5] cpufreq: get rid of
 get_online_cpus()/put_online_cpus()
Message-ID: <20111024113056.GA2635@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1318762607-2261-1-git-send-email-yong.zhang0@gmail.com>
 <1318762607-2261-6-git-send-email-yong.zhang0@gmail.com>
 <alpine.LFD.2.02.1110191110140.3240@ionos>
 <20111024024416.GB24581@zhy>
 <alpine.LFD.2.02.1110241123190.2642@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1110241123190.2642@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 11:24:51AM +0200, Thomas Gleixner wrote:
> 
> 
> On Mon, 24 Oct 2011, Yong Zhang wrote:
> 
> > On Wed, Oct 19, 2011 at 11:12:20AM +0200, Thomas Gleixner wrote:
> > > On Sun, 16 Oct 2011, Yong Zhang wrote:
> > > 
> > > > Fix below false positive (seems this is not a real deadlock scenario)
> > > > lockdep warning:
> > > 
> > > This looks like you caused it with patch 1.
> > 
> > Hmmm, yup.
> > CPU_DOWN_PREPARE will be under cpu_hotplug.lock.
> > 
> > > Both need a bit more
> > > thought, but thanks for catching that.
> > 
> > No sure whether it's big issue or not.
> > Mind showing more about your concern?
> 
> This is probably not the only place which will run into that issue and
> I have not much interest to patch all those sites.

If so, I think that kind of violation has been caught in mainline,
because mainline has had CPU_DOWN_PREPARE called under
cpu_hotplug.lock, right?

Or am I missing something?

Thanks,
Yong
