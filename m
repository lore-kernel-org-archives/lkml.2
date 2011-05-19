Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab1ESO77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:59:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64664 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1ESO76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:59:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kFtD0xznMMlcEWWvLv5UQ+zj98TW4KhYTfDxXajpbj0hZMaJK1PxuUO2IxMy3/Ildd
         YR4f2g1ObD95ukO0raT9MiLC2W2i/P+ff5knhx0ANJVf8/OBsfJbaFeWdSsU1EOjr1El
         ng8BtEKgIqSpmKw8tuKVQTqfmaIvtXbBppF0k=
Date: Thu, 19 May 2011 16:59:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH] perf: Split up buffer handling from core code
Message-ID: <20110519145951.GD1956@nowhere>
References: <1305767185-5771-1-git-send-email-fweisbec@gmail.com>
 <20110519073136.GB14049@liondog.tnic>
 <1305793931.2466.7191.camel@twins>
 <20110519141456.GB1956@nowhere>
 <1305816208.2466.7223.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305816208.2466.7223.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 04:43:28PM +0200, Peter Zijlstra wrote:
> On Thu, 2011-05-19 at 16:14 +0200, Frederic Weisbecker wrote:
> > 
> > Great. I kept it global because I read in a review from you
> > that you wanted it to stay a visible API. But if you're fine
> > with it internal, let's move it there. 
> 
> Well, its needed as an external symbol, but the inline isn't needed.

I thought it would be nice to keep it inline for core use, as it's called
pretty often from the overflow path.

A solution is to have a perf_output_copy_inline() in internal.h
and export it through perf_output_copy() in buffer.c

> I thought that the BTS code used it as well, but apparently that code
> doesn't anymore (or never did any my memory if fuzzy).

I thought it did too, but it actually use perf_output_sample().
