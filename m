Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab1F3Mlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:41:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51665 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab1F3Mlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:41:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bill Gatliff <bgat@billgatliff.com>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
Date: Thu, 30 Jun 2011 14:41:24 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
References: <1309430517-23821-1-git-send-email-s.hauer@pengutronix.de> <1309430517-23821-2-git-send-email-s.hauer@pengutronix.de> <BANLkTikQGFA7XcuAtEEi7_4m-j6-00sZ6Q@mail.gmail.com>
In-Reply-To: <BANLkTikQGFA7XcuAtEEi7_4m-j6-00sZ6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106301441.24493.arnd@arndb.de>
X-Provags-ID: V02:K0:LwZVuh4hKKML7oItW28dGvpq9GQZ8lr8PaJSMJ3m9fD
 cYQWhHVR0NaIpZsuqxt84Znip2BkDPanvhXFjnUdgZDLAYZp8y
 NfYXwAK74sVTDTR1O3E6PphG8S+BfDpdewfFBPDCN4D22ZcqOX
 vfXJz2vXjEoo5UC+EaMzhJVdi5b8CW433qzBzhPlmLry0aAt3c
 J+FXTIhF5Ediwef0/6HhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 June 2011, Bill Gatliff wrote:
> I'm completely against this effort.
> 
> The objections to my submission weren't ever because I was changing
> the user-visible API, so I don't think you can claim any advantage to
> mine in that regard.
> 
> I will take some blame for not getting my API finished, but I have
> been fighting some serious non-work issues that have consumed nearly
> all of my available time--- including the professional time I would
> otherwise have to invest in getting my code finished.
> 
> Is there the possibility that we could cooperate to get my patches
> finished, rather than discarding and reinventing them completely?

I've looked at your patches again, and it seems that you are doing
two distinct changes, both good:

1. You provide a generic framework for pwm drivers that makes it
possible for multiple drivers to coexist and simplifies the way
that these drivers interact with the core OS.

2. You extend and fix a number of aspects in the global PWM API.

Sascha's patch does only part 1, not part 2, but I don't think that
makes his patches any worse. The introduction of the framework
now is very similar to what you had suggested, and you should
probably be mentioned in the changelog, even though the two
implementations were done independently.

A lot of people want to see a framework get merged, and I think it's
great that Sascha has volunteered to do the work to push that
through this time, especially since you have not been able to
finish your work.

What I think would be the best plan forward is to merge Sascha's
patches as soon as we can, then get all currently existing pwm
drivers converted to that and moved to drivers/pwm, and finally
do the interface changes that you have proposed earlier.

I would also hope that you can give constructive feedback to
the submission and point out potential problems that you see
where the code should be changed now in order to make your
interface changes more easy later.

I realize that it's annoying to spend a lot of time on a specific
implementation and then see competing code get merged. Unfortunately,
this happens all the time, and the code we merge is often not
the one that has had the most effort spent on it, but the one that
looks most promising at the time when it gets merged.

	Arnd
