Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab2BCPLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:11:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33055 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab2BCPLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:11:36 -0500
Date: Fri, 3 Feb 2012 15:11:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Dave Martin <dave.martin@linaro.org>,
        "Mohd. Faris" <mohdfarisq2010@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] arm: vfp: Raising SIGFPE on invalid floating point
	operation
Message-ID: <20120203151125.GL889@n2100.arm.linux.org.uk>
References: <1328258184-23082-1-git-send-email-consul.kautuk@gmail.com> <20120203132717.GB2098@linaro.org> <CAFPAmTQ+XfBUQD2cr6WV04ndWji4zFhaOwvVVi8NaunH3TpkSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFPAmTQ+XfBUQD2cr6WV04ndWji4zFhaOwvVVi8NaunH3TpkSA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 08:07:02PM +0530, Kautuk Consul wrote:
> The **E bits(DZE/IOE/etc) are non-programmable on my system and they
> are set to 0
> however I try to play with them.

If the E bits are always zero, your VFP is incapable of _signalling_
the corresponding exception conditions.  Or, to put it another way,
those exception conditions are always masked.

And, if DZE is always zero, which is the divide-by-zero exception, then
obviously it won't raise an exception when you _do_ ask it to divide by
zero.  Instead, it will just set the cumulative exception status.

And, again, obviously, if it doesn't raise an exception, there is no
way for the system to deliver a SIGFPE to the user process.

Userspace does need to deal with this - as Dave points out, having
feenableexcept() return an error of the *E bits can't be set would
seem to be the sensible thing to do.  Whether or not user programs
even use that call (most, I suspect don't) is a separate problem.
