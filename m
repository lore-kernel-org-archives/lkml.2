Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0LIA3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 19:29:49 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52035 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0LIA3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 19:29:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=O228Bj4TgyNZ2ULoxcSEAI9EnC55rY3XNRk56HaZEShZinwjOWf+E/E0ZCNo5TWffz
         pLR7PuQsfFlcniIhZ+uA/Q4clWCGa+PQWc3zEj03smSNSCPe3KAcupwg/Yb2TS+UQgaB
         FASnPiF2A4Bcxn7Pmg0S7YlNW6d/KvOzFbKuA=
Date: Wed, 8 Dec 2010 22:29:42 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: "David S. Ahern" <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Add symfs option for off-box analysis using
 specified tree
Message-ID: <20101209002942.GA11252@ghostprotocols.net>
References: <1291776174-16535-1-git-send-email-daahern@cisco.com>
 <20101208205614.GD10353@ghostprotocols.net>
 <4D00052D.1020206@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D00052D.1020206@cisco.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 08, 2010 at 03:22:37PM -0700, David S. Ahern escreveu:
> On 12/08/10 13:56, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Dec 07, 2010 at 07:42:54PM -0700, David Ahern escreveu:
> >> +			if ((strlen(symbol_conf.symfs) != 0) ||
> > 
> > I suggest you use:
> > 
> > 			if (symbol_conf.symfs[1] ||
> > 
> > cheaper :)
> 
> Changed. I presume you meant: symbol_conf.symfs[0]  -- ie., element 0
> has something other than '\0' which means strlen > 0

Right, off-by-one mistake by me, sorry
 
> >> @@ -1778,17 +1786,20 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
> >>  			     const char *vmlinux, symbol_filter_t filter)
> >>  {
> >>  	int err = -1, fd;
> >> +	char symfs_vmlinux[PATH_MAX];
> >> -	fd = open(vmlinux, O_RDONLY);
> >> +	snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s/%s",
> >> +		 symbol_conf.symfs, vmlinux);
> > 
> > Its userspace, so stack is plenty, but I guess if using asprintf
> > wouldn't be better...
> > 
> > I.e. if we were programming some kernel module, creating a 4K stack
> > variable would be considered bad practice, so I think it is here as
> > well.
> 
> Declaring symfs_vmlinux on the stack is consistent with other PATH_MAX
> declarations within perf, and especially within util/symbol.c.

Ok, so keep it like that and I'll then work on a follow on patch to
remove these stack abuses.
 
> >> +	if (strlen(symbol_conf.symfs) == 0) {
> > 
> > Do it as:
> > 
> > 	if (!symbol_conf.symfs[1])
> > 		return 0;
> > 
> > And then the patch can be made smaller.
> 
> Done.
> 
> 
> I also added the symfs option to the Documentation files. Will send an
> updated patch.

Thanks a lot!

- Arnaldo
