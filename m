Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465Ab0LMRX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:23:59 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:57344 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab0LMRX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:23:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bsm/IdArO7MFEpT6c9TuizaGhaS8Tq6R7L+faxqLtzLbZmXtcMLZict1Lk/CDaMmOE
         xPbJ7IrBuHFNK2dtyct/aFzYn1ogewLOnUh6B+h3hNb7vf/qo34UtMKUABXN4SnHfb+w
         ktTxID+nUBlEOgXE7hIA9mXaSA1IobBNRVA8w=
Date: Mon, 13 Dec 2010 18:23:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Ahern" <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
Message-ID: <20101213172349.GD1691@nowhere>
References: <1291773285-16254-1-git-send-email-daahern@cisco.com>
 <1291773285-16254-2-git-send-email-daahern@cisco.com>
 <20101212201613.GA1784@nowhere>
 <4D06301C.2090309@cisco.com>
 <20101213155451.GA1691@nowhere>
 <20101213164854.GL5407@ghostprotocols.net>
 <20101213170923.GB1691@nowhere>
 <1292260289.6803.297.camel@twins>
 <1292260419.6803.300.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292260419.6803.300.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 06:13:39PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-13 at 18:11 +0100, Peter Zijlstra wrote:
> > 
> > Preferably, yes, but I don't see why we can't break the data file format
> > if we've got good reasons to. 
> 
> I mean, we pretty much _have_ to break data file format when we want to
> do splice() support.

Because we'll have one file per-cpu?

But perf.data on UP will be sensibly the same as today so I suspect
we won't need to be compatible.

But I guess I am missing something, in which case that probably doesn't
change much the picture. It's not because one day we'll need to break
the format that we can happily do so everyday. Backward compatibility
is important and we should preserve it when it's possible.
