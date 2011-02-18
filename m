Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab1BRRE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 12:04:59 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57377 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab1BRRE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 12:04:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=Nw+xepojZWg1WAhNJgHUnia+YMhOiCpsjzPT98ksjMQn2YTgVMeZNXDLSEXrhyFYG9
         /ox7n2vOwXhop3xaFO98oxw6QsrcW5/sVi1cb+2qR+qyZ/sdJj6ytzs55a98mJJF0oqj
         S0Pwr08J45SiMU4sDdy64rJSKpJd20wDOe2As=
Date: Fri, 18 Feb 2011 15:04:50 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org
Subject: Re: [PATCH 1/3] perf events: fix WARN_ON_ONCE for 64-bit raw data,
 SW events
Message-ID: <20110218170450.GB302@ghostprotocols.net>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
 <1298008433-22911-2-git-send-email-daahern@cisco.com>
 <1298026821.5226.642.camel@laptop>
 <4D5E8338.8010602@cisco.com>
 <20110218145348.GA302@ghostprotocols.net>
 <1298041291.5226.776.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298041291.5226.776.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 18, 2011 at 04:01:31PM +0100, Peter Zijlstra escreveu:
> On Fri, 2011-02-18 at 12:53 -0200, Arnaldo Carvalho de Melo wrote:
> > > So size should be changed to u64 rather than modifying the
> > WARN_ON_ONCE?
> > 
> > Yeah, I guess so, 32-bit has to die it seems, gets in the way of
> > testing
> > :-) 
> 
> No!
> 
> 1) don't use RAW unless you have to
> 2) you don't have to, goto 1
> 3) if you do anyway, ensure its properly padded

Ok, but using that struct definition on 32-bit land, will lead to non 8 byte
alignment, right?

- Arnaldo
