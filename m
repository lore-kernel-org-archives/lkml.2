Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2FNVV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 17:21:58 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4289 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756294Ab2FNVVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 17:21:55 -0400
Message-ID: <1339708913.5981.16.camel@x61.thuisdomein>
Subject: Re: [PATCH] init: add comments to keep initcall-names in sync with
 initcall levels
From: Paul Bolle <pebolle@tiscali.nl>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, bp@amd64.org,
        pawel.moll@arm.com, jbaron@redhat.com, gregkh@linuxfoundation.org
Date: Thu, 14 Jun 2012 23:21:53 +0200
In-Reply-To: <CAJfuBxxBD5eiMMTW5+q6LEpv+WLcbcsxxY6eEjbaTVCFqBeKmA@mail.gmail.com>
References: <20120612105913.GA8404@aftab.osrc.amd.com>
	 <1339699862-3731-1-git-send-email-jim.cromie@gmail.com>
	 <1339701783.5981.5.camel@x61.thuisdomein>
	 <CAJfuBxxBD5eiMMTW5+q6LEpv+WLcbcsxxY6eEjbaTVCFqBeKmA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 14 Jun 2012 21:21:53.0808 (UTC) FILETIME=[B857F900:01CD4A73]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 14:32 -0600, Jim Cromie wrote:
> On Thu, Jun 14, 2012 at 1:23 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > On Thu, 2012-06-14 at 12:51 -0600, Jim Cromie wrote:
> >>
> >> -/* Don't use these in modules, but some people do... */
> >> +/* Don't use these in loadable modules, but some people do... */
> >
> > What problem does this solve?
> 
> kernel/params.c  and other builtins are also modules - at least wrt
> how theyre reported by dynamic_debug:
> 
> kernel/params.c:121 [params]parse_one =_ "Unknown argument `%s'\012"
> kernel/params.c:117 [params]parse_one =_ "Unknown argument: calling %p\012"
> kernel/params.c:108 [params]parse_one =_ "They are equal!  Calling %p\012"
> kernel/params.c:188 [params]parse_args =_ "Parsing ARGS: %s\012"
> 
> The advice to avoid those macros does not apply to builtin "modules"

I don't think I use dynamic_debug, but still, a pair of square brackets
doesn't make that some part of the kernel is considered to be a module,
does it? And more importantly, even if there's a difference between
"module" and "loadable module", which I rather doubt, aren't the people
who are expected to read this comment also expected to understand the
relevance of the preceding 
    #else /* MODULE */

line?


Paul Bolle

