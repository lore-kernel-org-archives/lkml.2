Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab0H1CFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 22:05:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49457 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab0H1CFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 22:05:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=EWudX9VGlLN/BjpET0QJLGEtqCUG6HKwBvGn/HiEH9FupymAqmi2k4fFCOgqrdSyov
         Y4ZzsY3p/XsMLSzr0kf+3V69nmX0tTIki+ZlrtUdMKoSe96Pbqyjo/RbDdpT0c8hj6v8
         xgueIA5pV03KPcR+wRn0R6ixsgv5RzYQT7Xic=
Date: Fri, 27 Aug 2010 19:05:40 -0700
From: mark gross <markgross@thegnar.org>
To: skannan@codeaurora.org
Cc: markgross@thegnar.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <james.bottomley@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, khilman@deeprootsystems.com
Subject: Re: [PATCH] pm_qos: Add system bus performance parameter
Message-ID: <20100828020540.GB8341@gvim.org>
Reply-To: markgross@thegnar.org
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
 <1282882403-29824-2-git-send-email-skannan@codeaurora.org>
 <20100827064153.GB3414@gvim.org>
 <b3ebe52382d37d37e93021c33cb4d6d9.squirrel@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3ebe52382d37d37e93021c33cb4d6d9.squirrel@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 01:10:55AM -0700, skannan@codeaurora.org wrote:
> 
> > nack.
> >
> > Change the name to system_bus_throughput_pm_qos assuming KBS units and
> > I'll ok it.  It needs to be portable and without units I think drivers
> > will start using magic numbers that will break when you go from a
> > devices with 16 to 32 bus with the same clock.
> >
> > We had an email thread about this last year
> > http://lkml.org/lkml/2009/12/31/143
> > I don't recall solution ever coming out of it.   I think you guys didn't
> > like the idea of using units.  Further I did post a patch adding
> > something like using units. Although I looks like I botch the post the
> > linux-pm as I can't seem to find it in the linux-pm archives :(
> > http://lkml.org/lkml/2010/4/22/213
> >
> > Would you be ok with using throughput instead of a unit less performance
> > magic number?
> >
> >
> > --mark
> 
> Ignoring other details for now, the biggest problem with throughput/KBps
> units is that PM QoS can't handle it well in its current state. For KBps
> the requests should be added together before it's "enforced". Just picking
> the maximum won't work optimally.

well then current pm_qos code for network throughput takes the max.

> Another problem with using KBps is that the available throughput is going
> to vary depending on the CPU frequency since the CPU running at a higher
> freq is going to use more bandwidth/throughput than the same CPU running
> at a lower freq.

um, if your modem SPI needs a min freq its really saying it needs a min
throughput (throughput is just a scaler times freq, and 8KBS is a 13 bit
shift away from HZ for SPI)

> A KHz unit will side step both problems. It's not the most ideal in theory
> but it's simple and gets the job done since, in our case, there aren't
> very many fine grained levels of system bus frequencies (and corresponding
> throughputs).

I think your getting too wrapped up with this Hz thing and need write a
couple of shift macros to convert between Kbs and Hz and be happy.

> 
> I understand that other architectures might have different practical
> constraints and abilities and I didn't want to impose the KHz limitation
> on them. That's the reason I proposed a parameter whose units is defined
> by the "enforcer".

The problem is that doing this will result in too many one-off drivers
that don't port nicely to my architecture when I use the same
peripheral as you.

> Thoughts?
>
not really anything additional, other than I wonder why kbs isn't
working for you.  Perhaps I'm missing something subtle.

--mark

