Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab0ESIqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 04:46:38 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63829 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab0ESIqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 04:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZiAjwMF8ycSpdpxIKaehBth10LGZeSIYwjlV9eWSTaNtAadJQpDaE9/HRdUsPbiZOI
         rA4sYLsnBSZNFf1joYYdaxnxNEVpttsyg/DLKUPjgRMWtwHPUjFghSNQ+7BZbKqj2ZY4
         RLe8gedvJbSSKhykDCvdC0NphWc/3FLPy/JvM=
Date: Wed, 19 May 2010 10:46:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, gorcunov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [watchdog] separate hardlockup/softlockup enable
	paths
Message-ID: <20100519084638.GH5704@nowhere>
References: <1274133966-18415-1-git-send-email-dzickus@redhat.com> <1274133966-18415-3-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274133966-18415-3-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 06:06:05PM -0400, Don Zickus wrote:
> In preparation to support the backwards compatible option nmi_watchdog properly
> from the kernel commandline, the enable/disable paths for the hardlockup and
> softlockup code needed to separated more cleanly.
> 
> The code is re-arranged a bit to create a watchdog_softlockup_enable/disable
> function to mimic the hardlockup counterpart.  In addition, a softlockup callback
> is created to make it easy to turn the softlockup code on/off with out interfering
> with the hardlockup code.
> 
> The functionality should still be the same.



I don't think we want this really. The unification is not only a good
thing for maintainance and genericity of code but also for the fact now
we don't need anymore to worry about which watchdog to turn on/off.

The fact is often when you have a lockup, you don't even know if it
is soft or hard. If you are on X, you won't know.

So people just don't bother about such granularity of control, they simply
enable or disable both detectors.

I would suggest you to let the things how they are and not making the code
more complicated for something that won't be used.

Just forget about the nmi_watchdog file. A simple watchdog file to control
everything is much better.

Thanks.

