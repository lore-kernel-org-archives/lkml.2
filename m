Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab0KXOJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:09:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab0KXOJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:09:24 -0500
Date: Wed, 24 Nov 2010 09:08:59 -0500
From: Don Zickus <dzickus@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com, gorcunov@openvz.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86, nmi_watchdog:  remove the old nmi_watchdog
Message-ID: <20101124140859.GC22165@redhat.com>
References: <1290540725-2911-1-git-send-email-dzickus@redhat.com>
 <1290540725-2911-3-git-send-email-dzickus@redhat.com>
 <4CEC853B.6080508@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEC853B.6080508@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 07:23:39PM -0800, Yinghai Lu wrote:
> > -	{
> > -		.procname       = "nmi_watchdog",
> > -		.data           = &nmi_watchdog_enabled,
> > -		.maxlen         = sizeof (int),
> > -		.mode           = 0644,
> > -		.proc_handler   = proc_nmi_enabled,
> > -	},
> 
> wonder if you can keep nmi_watchdog in sysctl? So in run-time it could be disabled after it booted up.

Well, with the new code I have watchdog_enabled which does the same thing.
With the nmi watchdog moving to generic code, the idea was to call it a
hardlockup detector.  I guess I was trying to rename things to avoid using
nmi all over the place to reflect the idea that a hardlockup might be able
to be used by something other than an nmi.

I can probably wrap this around watchdog_enabled to preserve it I suppose.
Let me know.

Cheers,
Don
