Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2K1VnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:43:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab2K1VnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:43:11 -0500
Date: Wed, 28 Nov 2012 16:42:54 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, mingo@kernel.org,
        namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 31/32] perf, tools: Default to cpu// for events v3
Message-ID: <20121128194254.GB27608@infradead.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
 <1352510868-7911-32-git-send-email-andi@firstfloor.org>
 <20121128155313.GF1038@krava.brq.redhat.com>
 <20121128190436.GR16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121128190436.GR16230@one.firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 28, 2012 at 08:04:36PM +0100, Andi Kleen escreveu:
> > > +static void str_append(char **s, int *len, const char *a)
> > > +{
> > > +	int olen = *s ? strlen(*s) : 0;
> > > +	int nlen = olen + strlen(a) + 1;
> > > +	if (*len < nlen) {
> > > +		*len = *len * 2;
> > > +		if (*len < nlen)
> > > +			*len = nlen;
> > > +		*s = realloc(*s, *len);
> > > +		if (!*s)
> > > +			exit(ENOMEM);
> > 
> > Rather use BUG_ON or event better return -ENOMEM.
> 
> Neither makes sense: the callers won't handle it and it's not a bug.
> If you're out of memory in user space the only thing you can do is to 
> exit.

Nope, just propagate it back and handle at the callers, the memory
exhaustion may be temporary, just warn the user.

- Arnaldo
 
> > 
> > > +		if (olen == 0)
> > > +			**s = 0;
> > > +	}
> > > +	strcat(*s, a);
> > > +}
> > 
> > Could this one be moved to util/string.c in some generic form?
> 
> Ok.
> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.
