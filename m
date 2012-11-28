Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab2K1TEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:04:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59889 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab2K1TEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:04:42 -0500
Date: Wed, 28 Nov 2012 20:04:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, eranian@google.com,
        mingo@kernel.org, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 31/32] perf, tools: Default to cpu// for events v3
Message-ID: <20121128190436.GR16230@one.firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org> <1352510868-7911-32-git-send-email-andi@firstfloor.org> <20121128155313.GF1038@krava.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121128155313.GF1038@krava.brq.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static void str_append(char **s, int *len, const char *a)
> > +{
> > +	int olen = *s ? strlen(*s) : 0;
> > +	int nlen = olen + strlen(a) + 1;
> > +	if (*len < nlen) {
> > +		*len = *len * 2;
> > +		if (*len < nlen)
> > +			*len = nlen;
> > +		*s = realloc(*s, *len);
> > +		if (!*s)
> > +			exit(ENOMEM);
> 
> Rather use BUG_ON or event better return -ENOMEM.

Neither makes sense: the callers won't handle it and it's not a bug.
If you're out of memory in user space the only thing you can do is to 
exit.

> 
> > +		if (olen == 0)
> > +			**s = 0;
> > +	}
> > +	strcat(*s, a);
> > +}
> 
> Could this one be moved to util/string.c in some generic form?

Ok.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
