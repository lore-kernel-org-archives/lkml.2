Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab0CaQ0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 12:26:54 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:42685 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab0CaQ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 12:26:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jDKrzww7wNBkPGTRKkzWosP6eM2XU0/dNLMFxmR8uGeNBS/lhV/3OEkjnehBQ+9bc1
         F0DeVrIdgxDHk+i9+3CzVqx+WAVf7WBaXO22aSQRnI3K6nkTde6zQgXmZuf0mDmr8aLl
         Fo+Y0sz0nWn8Sd7NoU1RwmzcIVKyenQu8TCLQ=
Date: Wed, 31 Mar 2010 20:26:47 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
       Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
Message-ID: <20100331162647.GA15288@lenovo>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com> <bd4cb8901003300311l4178891dvf1e63293a0ac51fe@mail.gmail.com> <20100330134145.GI11907@erda.amd.com> <bd4cb8901003300653lc8e414bp3930b03fee2fffbf@mail.gmail.com> <1269961255.5258.221.camel@laptop> <20100330155949.GJ11907@erda.amd.com> <1269968113.5258.442.camel@laptop> <20100330182906.GD5211@lenovo> <1269975840.5258.609.camel@laptop> <20100331161523.GA9058@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331161523.GA9058@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 08:15:23PM +0400, Cyrill Gorcunov wrote:
> On Tue, Mar 30, 2010 at 09:04:00PM +0200, Peter Zijlstra wrote:
> > On Tue, 2010-03-30 at 22:29 +0400, Cyrill Gorcunov wrote:
> [...]
> > > 
[...]
> +static inline bool p4_is_odd_cpl(u32 escr)
> +{
> +	unsigned int t0 = (escr & P4_ESCR_T0_ANY) << 0;
> +	unsigned int t1 = (escr & P4_ESCR_T1_ANY) << 2;
> +
> +	if ((t0 ^ t1) != t0)
> +		return true;

/me in shame: This is bogus, Peter don't take it yet.

> +
> +	return false;
> +}
[...]

	-- Cyrill
