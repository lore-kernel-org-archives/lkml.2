Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab0LPQXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:23:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0LPQXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:23:11 -0500
Date: Thu, 16 Dec 2010 11:22:55 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: kdump broken on 2.6.37-rc4
Message-ID: <20101216162255.GE13870@redhat.com>
References: <20101209124117.GA6032@redhat.com>
 <4D01377B.5070809@kernel.org>
 <20101213100848.GA2237@redhat.com>
 <4D0663F0.2060103@kernel.org>
 <4D06783C.6040009@zytor.com>
 <20101214224135.GB19693@redhat.com>
 <20101215103954.GA2243@redhat.com>
 <4D09958D.2040907@kernel.org>
 <20101216100050.GA2261@redhat.com>
 <4D0A3B69.6080700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0A3B69.6080700@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 08:16:41AM -0800, H. Peter Anvin wrote:
> On 12/16/2010 02:00 AM, Stanislaw Gruszka wrote:
> > On Wed, Dec 15, 2010 at 08:29:01PM -0800, Yinghai Lu wrote:
> >> please check
> >>
> >> [PATCH] x86, crashkernel, 32bit: only try to get range under 512M
> >>
> >> Steanishlaw report kdump is 32bit is broken.
> > LOL
> > 
> >> in misc.c for decompresser, it will do sanity checking to make sure heap
> >> heap under 512M.
> >>
> >> So limit it in first kernel under 512M for 32bit system.
> >>
> >> Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > 
> > Patch fix problem on my T-60 laptop.
> > 
> > As expected patch does not help on my other T-500 x86_64 system,
> > kdump not work there, but perhaps this is a different problem,
> > I'm going to check it.
> > 
> 
> I think limiting kdump below 512 MiB on 32 bits may make sense; perhaps
> even on 64 bits.  It's pretty conservative, after all...
> 
> Opinions?

Actually it will be good to know why 512MB. I know in the past we have
been talking of reserving memory in higher memory regions and Neil Horman
had been trying to boot bzImage in 64 bit mode so that it can be run
from higher addresses. 

So right now limiting it is easy but it is desirable to be able to run
bzImage from as high a address as possible and knowing why to limit it
to 512MB can help see if there is a way to get rid of that limitation.

I probably would not worry about 32bit systems but for 64 bit, I
cerntainly want to make it boot from higher addresses (if it is possible
technically).

Thanks
Vivek
