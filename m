Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1BRRNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 12:13:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48300 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1BRRNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 12:13:35 -0500
Subject: Re: [PATCH 1/3] perf events: fix WARN_ON_ONCE for 64-bit raw data,
 SW events
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org
In-Reply-To: <20110218170450.GB302@ghostprotocols.net>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
	 <1298008433-22911-2-git-send-email-daahern@cisco.com>
	 <1298026821.5226.642.camel@laptop> <4D5E8338.8010602@cisco.com>
	 <20110218145348.GA302@ghostprotocols.net>
	 <1298041291.5226.776.camel@laptop>
	 <20110218170450.GB302@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Feb 2011 18:13:09 +0100
Message-ID: <1298049189.2887.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 15:04 -0200, Arnaldo Carvalho de Melo wrote:
> Em Fri, Feb 18, 2011 at 04:01:31PM +0100, Peter Zijlstra escreveu:
> > On Fri, 2011-02-18 at 12:53 -0200, Arnaldo Carvalho de Melo wrote:
> > > > So size should be changed to u64 rather than modifying the
> > > WARN_ON_ONCE?
> > > 
> > > Yeah, I guess so, 32-bit has to die it seems, gets in the way of
> > > testing
> > > :-) 
> > 
> > No!
> > 
> > 1) don't use RAW unless you have to
> > 2) you don't have to, goto 1
> > 3) if you do anyway, ensure its properly padded
> 
> Ok, but using that struct definition on 32-bit land, will lead to non 8 byte
> alignment, right?

Nope, its just fine.. it defaults to an empty 4byte payload ;-)

Its just that any custom payload must be of size 4+8*n bytes.
