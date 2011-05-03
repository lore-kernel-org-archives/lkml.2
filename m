Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1ECXMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:12:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51820 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab1ECXMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZJWboZ05LJlcfLineWViYCwEj3Tb1smkXUXMp7tzM9Dx6Gjsr+Y3kZVgspPzClXEjI
         i7kPKlgHdWbjBGMIUAV4ubjUmtI7+MrbplXbScIaEcWUOgdGfaGYzv4iHBfDZvz91Jxr
         OkpZn3H0b5ACarTzaeMz9wr1R62eOMeWtS2Gc=
Date: Wed, 4 May 2011 01:12:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86: Allow the user not to build hw_breakpoints
Message-ID: <20110503231241.GG2678@nowhere>
References: <1303923602-2923-1-git-send-email-fweisbec@gmail.com>
 <1303923602-2923-4-git-send-email-fweisbec@gmail.com>
 <4DB854AA.6070101@zytor.com>
 <20110427182633.GB1753@nowhere>
 <008d59a3-bd23-4cb3-8a73-1640137e3ac4@email.android.com>
 <20110427195004.GA3654@nowhere>
 <4DC020D9.3050000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC020D9.3050000@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 08:35:53AM -0700, H. Peter Anvin wrote:
> On 04/27/2011 12:50 PM, Frederic Weisbecker wrote:
> > On Wed, Apr 27, 2011 at 11:54:17AM -0700, H. Peter Anvin wrote:
> >> Why do you have to be able to disable breakpoints to disable perf? That seems seriously backwards, especially since we had breakpoints long before perf...
> > 
> > That started when we implemented breakpoints as counters. Then we realized that
> > ptrace had its own scheduling that was somehow duplicating what perf was doing.
> > So we have finally unified that under perf. The good point is that archs don't need
> > to care much about ptrace breakpoints tracking, just the interface.
> > 
> > But yeah the bad point is that dependency.
> 
> It really is very bad... without breakpoints, you lose almost all
> debugging support.

Right, so it should be fine for embedded environment to disable breakpoints.
It depends on CONFIG_EXPERT now.
