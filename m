Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab0H1Bzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 21:55:36 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:38743 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0H1Bzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 21:55:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=SM7i4Vpe089m2eEvaVpsqyH3LlF+t4ZLcnNptdC30/WgjKgUkBkOh6WEKpPgPkEOMA
         hrQveowsqnNGwJaOEOkYuyBfLeKTqEWQlpOHvEoqIfGED+y3NxtRQyypp6OY+VRm1Rhh
         R7NdJv9PsVcRzJQPKmRoJcoka4hXl6YUBr4pI=
Date: Fri, 27 Aug 2010 18:55:31 -0700
From: mark gross <markgross@thegnar.org>
To: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@suse.de>,
        mark gross <markgross@thegnar.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] pm_qos: Add system bus performance parameter
Message-ID: <20100828015531.GA8341@gvim.org>
Reply-To: markgross@thegnar.org
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
 <1282882403-29824-2-git-send-email-skannan@codeaurora.org>
 <87hbigqg8d.fsf@deeprootsystems.com>
 <4C7804DE.9020008@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7804DE.9020008@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 11:33:02AM -0700, Bryan Huntsman wrote:
> Kevin Hilman wrote:
> >Saravana Kannan <skannan@codeaurora.org> writes:
> >
> >>Some drivers/devices might need some minimum system bus performance to
> >>provide acceptable service. Provide a PM QoS parameter to send these requests
> >>to.
> >>
> >>The new parameter is named "system bus performance" since it is generic enough
> >>for the unit of the request to be frequency, bandwidth or something else that
> >>might be appropriate. It's up to each implementation of the QoS provider to
> >>define what the unit of the request would be.
> >>
> >>Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> >
> >With this current design, only one system-wide bus would be managed.
> >What if a platform has more than one independently scalable bus?
> >
> >I think the only scalable way to handle this kind of thing is to have
> >per-device QoS constraints that can then be combined/aggregated by parent
> >devices/busses.
> >
> >At LPC this year, I've proposed per-device QoS constraints[1] as a topic
> >for the PM mini-conf.  I hope some folks from the MSM camp can be there
> >for these discussions.
> >
> >Kevin
> >
> >[1] http://www.linuxplumbersconf.org/2010/ocw/proposals/819
> 
> Yeah, I'm planning on rounding up some MSM folks for LPC this year.
> Power is a big concern for us so it would be good to join the
> discussion.  Initially, I was very keen on the per-device QoS
> contraints but I've since cooled on it.  For our HW, there's not a
> generic unit that can convey enough data for us to act on.  At least
> not w/o lookup tables, etc., at which point the unit loses it's
> value and becomes a generic handle.  I'm looking forward to a good
> group discussion on this topic.  Thanks.
> 
>
I am looking forward to a good discussion too :)

It would be cool if we had a prototype for the per-device qos
constraint idea to use to help guide the discussion.

Power is a big concern for everyone, and everyone doing SOC's have
all have about the same issues to boot with spi, sdio i2c power domains
and clock domains.

If msm is having issues I bet IA and Omap are or soon will have the
exact same class of issues to solve the kernel.

--mark

