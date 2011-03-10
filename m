Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1CJVeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:34:44 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36153 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1CJVen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:34:43 -0500
MIME-Version: 1.0
In-Reply-To: <201103100836.54361.alexander.stein@systec-electronic.com>
References: <1299701596-24665-1-git-send-email-bgat@billgatliff.com>
	<1299701596-24665-4-git-send-email-bgat@billgatliff.com>
	<201103100836.54361.alexander.stein@systec-electronic.com>
Date: Thu, 10 Mar 2011 15:34:42 -0600
Message-ID: <AANLkTik7VgWW8r-fU5FuekxJGH-n6NxUdGJtfB-OXv6B@mail.gmail.com>
Subject: Re: [PWM v7 3/3] PWM: Atmel PWMC driver
From: Bill Gatliff <bgat@billgatliff.com>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander:

On Thu, Mar 10, 2011 at 1:36 AM, Alexander Stein
<alexander.stein@systec-electronic.com> wrote:
> As far as I can see, the previosly support for pwm_channel_handler has been
> dropped. The new API doesn't support such things.
> What do you think about adding this? It might be important to change the PWM
> setup after a specific amount of time.

Reviewers of the implementation noted some race conditions, and had
additional objections to the implementation.  They suggested that I
reimplement channel handlers using genirq.

Since the pwm_channel_handler implementation was broken, I removed it
from the implementation.  I haven't yet started on the genirq-based
approach, for two reasons: I'm trying to get everything else into
mainline; and, I'm not quite sure yet how to stitch genirq together
with "genpwm".

There is a larger question, however, that I would like to hear your
answer on since you seem interested in the subject: are end-of-period
callbacks really necessary?  If you are trying to "ramp" a PWM signal
from a low duty cycle to a high one, would an hrtimer suffice?
Assuming that a PWM device driver can implement duty cycle and/or
period changes without glitches, is it really necessary to stay so
tightly synchronized to the PWM signal the way that an end-of-period
callback would allow?

In my work, I haven't encountered a need for end-of-period callbacks
when doing mere PWM signal generation (though the topic is very
important when counting pulses, which I'm considering a different
implementation/API for).  I don't know if my experience is
comprehensive, however.  Would love to hear your opinion.


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
