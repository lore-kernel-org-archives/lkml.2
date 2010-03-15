Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab0COR4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 13:56:24 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59537 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab0COR4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 13:56:22 -0400
Date: Mon, 15 Mar 2010 13:56:11 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [PATCH 1/2] kmod: add init function to usermodehelper
Message-ID: <20100315175611.GA24528@hmsreliant.think-freely.org>
References: <20100315122908.GB16175@hmsreliant.think-freely.org>
 <20100315123355.GC16175@hmsreliant.think-freely.org>
 <20100315173454.GA7976@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315173454.GA7976@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.2 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 06:34:54PM +0100, Oleg Nesterov wrote:
> On 03/15, Neil Horman wrote:
> >
> > --- a/kernel/kmod.c
> > +++ b/kernel/kmod.c
> > @@ -116,27 +116,16 @@ int __request_module(bool wait, const char *fmt, ...)
> >
> >  	trace_module_request(module_name, wait, _RET_IP_);
> >
> > -	ret = call_usermodehelper(modprobe_path, argv, envp,
> > -			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
> > +	ret = call_usermodehelper_fns(modprobe_path, argv, envp,
> > +			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC,
> > +			NULL, NULL, NULL);
> 
> This change looks unnecessary, but doesn't hurt.
> 
Yeah, I concur, it was part of the origional patch, when that
call_usermodehelper had already been replaced with call_usermodehelper_cleanup.
I made my change anyway, figuring part of the purpose of this longer term would
be to convert the call_usermodehelper functions to the init/cleanup enabled
variants, which andi's patchset will eventually do here
Neil

> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> 
> 
