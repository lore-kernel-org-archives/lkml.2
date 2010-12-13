Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab0LMRWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:22:25 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42947 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab0LMRWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:22:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=oZ98y7X/YyxzeKU0Lze0k0ZVRfydSjfMQpHS95w0bXd9W9U4Cs748z1rCfMHjTJ9zp
         sDG8LbyAfyqo46lzE/14USOLxo17nPhvhta9cnlDfmZxLJHL+es8QHVvsl+xiCfIxvwM
         XWbtSLGy8Uo74yHUHNxbr4mHEbvJG1t+lE7fw=
Date: Mon, 13 Dec 2010 15:22:16 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "David S. Ahern" <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
Message-ID: <20101213172216.GB7417@ghostprotocols.net>
References: <1291773285-16254-1-git-send-email-daahern@cisco.com>
 <1291773285-16254-2-git-send-email-daahern@cisco.com>
 <20101212201613.GA1784@nowhere>
 <4D06301C.2090309@cisco.com>
 <20101213155451.GA1691@nowhere>
 <20101213164854.GL5407@ghostprotocols.net>
 <20101213170923.GB1691@nowhere>
 <1292260289.6803.297.camel@twins>
 <20101213171537.GC1691@nowhere>
 <1292260699.6803.305.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292260699.6803.305.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 13, 2010 at 06:18:19PM +0100, Peter Zijlstra escreveu:
> On Mon, 2010-12-13 at 18:15 +0100, Frederic Weisbecker wrote:
> > On Mon, Dec 13, 2010 at 06:11:29PM +0100, Peter Zijlstra wrote:
> > > On Mon, 2010-12-13 at 18:09 +0100, Frederic Weisbecker wrote:
> > > > So this should be the last one to add. Something like PERF_RECORD_GEN_EVT
> > > > that has a field in its headers containing a sub-type which can be this
> > > > wall clock but can also host about everything in the future.
> > > > 
> > > > This way we don't propagate more the possible overlap with the kernel. 
> > > 
> > > I don't see why we should add more, that's going the wrong direction.
> > 
> > This must be the last one.
> 
> No, the last one already happened, you cannot postpone the last one,
> there will always be another excuse.

Did you understand the use case? How to have multiple reference times
when appending?

"last one" means adding a multiplexor, PERF_RECORD_LAST_ONE if you will,
and inside it we add new events if the need arises. Then never again we
add a PERF_RECORD_ event in userspace.

- Arnaldo
