Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367Ab1ERSCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:02:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53214 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab1ERSC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:02:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iaUFKiuGoyifPFsO+FBDPWz4Zq2CSxzOPr9Kacrs6SZEKn/uw0QOlmo+cEaaxI+OB4
         4pc4SRzajZxgywqbJMbt3auLKXfMS/X6QmOZCsaqouS3HQ5CsGfTJtakm6zpW7mNX9dB
         N/9Kp3La7COuryFuMkAp75LnZAiaHzu7HEpRA=
Date: Wed, 18 May 2011 20:02:24 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC v3 0/8] x86, xsave: rework of extended state handling, LWP
 support
Message-ID: <20110518180224.GA24932@alberich.amd.com>
References: <4D91FA76.1010908@zytor.com>
 <1302018656-586370-1-git-send-email-hans.rosenfeld@amd.com>
 <20110407072305.GA20291@elte.hu>
 <20110516191012.GA575@escobedo.osrc.amd.com>
 <20110517113020.GA13475@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517113020.GA13475@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 01:30:20PM +0200, Ingo Molnar wrote:
> 
> * Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:
> 
> > Hi,
> > 
> > On Thu, Apr 07, 2011 at 03:23:05AM -0400, Ingo Molnar wrote:
> > > 
> > > FYI, the bits in tip:x86/xsave crash on boot on an AMD X2 testbox:
> > 
> > > Full crashlog and kernel config attached. I've excluded x86/save from 
> > > tip:master for now.
> > 
> > this issue has been fixed a few weeks ago.
> > 
> > Are there any plans to include x86/xsave into tip:master again?
> 
> Regarding the LWP bits, that branch was indeed excluded because of that crash, 
> while re-checking the branch today i noticed at least one serious design error 
> in it, which makes me reconsider the whole thing:

Independend of all the concerns and useful comments regarding LWP ...
it seems to me that patches 1-7 are still of use (cleaning up the
save/restore code making it more maintainable).

Wouldn't it make sense to add patches 1-7 to a branch that is tested
with linux-next to find potential regressions?


Andreas
