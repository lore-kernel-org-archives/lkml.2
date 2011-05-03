Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab1ECXyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:54:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47067 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab1ECXyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iDI8PRQ1RkL0Wd0A81B4kxqhO+WRumv1UdQ5YnFzK9r52J/vM78Rtt5ajb6IIxhMDz
         onpTxA++ARU7pA1v4ZV9GZZnntrj22xO78FpYk1oQIE9RszR/0b4m+bL8q0JdA7i4o4P
         AromxTtXJy2vwIEKZRplLKqX8f87PePaQuNTE=
Date: Wed, 4 May 2011 01:54:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86: Allow the user not to build hw_breakpoints
Message-ID: <20110503235434.GI2678@nowhere>
References: <1303923602-2923-1-git-send-email-fweisbec@gmail.com>
 <1303923602-2923-4-git-send-email-fweisbec@gmail.com>
 <4DB854AA.6070101@zytor.com>
 <20110427182633.GB1753@nowhere>
 <008d59a3-bd23-4cb3-8a73-1640137e3ac4@email.android.com>
 <20110427195004.GA3654@nowhere>
 <4DC020D9.3050000@zytor.com>
 <20110503231241.GG2678@nowhere>
 <4DC0925E.20507@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC0925E.20507@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 04:40:14PM -0700, H. Peter Anvin wrote:
> On 05/03/2011 04:12 PM, Frederic Weisbecker wrote:
> >>
> >> It really is very bad... without breakpoints, you lose almost all
> >> debugging support.
> > 
> > Right, so it should be fine for embedded environment to disable breakpoints.
> > It depends on CONFIG_EXPERT now.
> 
> Uh... even embedded environments need to be able to debug.

For development yeah, but is it needed for production evironments?

May be sometimes. But even though, the main functionalities of
ptrace are still available since instruction breakpoints are
implemented through int3 and not debugreg in ptrace. Only data
breakpoints would be unusable, but I believe they are a minor use compared
to instruction breakpoints. I rarely make use of them for debugging
personally.

That's really deemed for specific cases where people know what
they are doing.
