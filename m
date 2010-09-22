Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab0IVDPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 23:15:10 -0400
Received: from void.printf.net ([89.145.121.20]:38923 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab0IVDPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 23:15:08 -0400
Date: Wed, 22 Sep 2010 04:14:53 +0100
From: Chris Ball <cjb@laptop.org>
To: Valdis.Kletnieks@vt.edu
Cc: akpm@linux-foundation.org, Richard Purdie <rpurdie@rpsys.net>,
        Hein_Tibosch <hein_tibosch@yahoo.es>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: mmotm 2010-09-15 - BUG in mmc driver calling
	led_trigger_event()
Message-ID: <20100922031452.GA4862@void.printf.net>
References: <201009152352.o8FNqXGr022752@imap1.linux-foundation.org> <8581.1285124507@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8581.1285124507@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Valdis,

On Tue, Sep 21, 2010 at 11:01:47PM -0400, Valdis.Kletnieks@vt.edu wrote:
> [    2.934051] BUG: sleeping function called from invalid context at kernel/mutex.c:278
> [    2.934440] in_atomic(): 1, irqs_disabled(): 0, pid: 11, name: kworker/0:1
>
> [...]
> 
> Anything obvious to you guys? Race condition of some sort, or somebody
> else leaving a dangling in_atomic() status for us to get ambushed by?
> Maybe Hein's patches to retry at multiple freqs are causing one of the
> retries to happen at a bad time? I'm mystified.

This is caused by Anton Vorontsov's patchset here:
   http://lkml.org/lkml/2010/7/14/127

I reported the same symptom:
   http://lkml.org/lkml/2010/9/8/435

and suggested that Andrew remove the patchset from -mm while we work out
the bugs.

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
