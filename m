Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691Ab1ESRXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:23:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41664 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933494Ab1ESRXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fi7tkCFvqgpTeUaGPZ87ipr+NQ4Nqn3SIV3X+W4YEYBgCYqXoGr8KY+7qgXw9FTRZm
         9qi6fGu+601o3YNpWUGpsMR1vbN0J9W8cYdgWYsl+wnfsicy1jx6/VnePDfaniQCUwuX
         mYw66Pfvscg0VBDzgNz+2rLBsY4w1E8wG/BUs=
Date: Thu, 19 May 2011 19:23:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH] perf: Split up buffer handling from core code
Message-ID: <20110519172331.GF1956@nowhere>
References: <1305767185-5771-1-git-send-email-fweisbec@gmail.com>
 <20110519073136.GB14049@liondog.tnic>
 <1305793931.2466.7191.camel@twins>
 <20110519141456.GB1956@nowhere>
 <1305816208.2466.7223.camel@twins>
 <20110519145951.GD1956@nowhere>
 <1305818041.2466.7225.camel@twins>
 <20110519172039.GA27370@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519172039.GA27370@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 07:20:39PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Thu, 2011-05-19 at 16:59 +0200, Frederic Weisbecker wrote:
> > > I thought it would be nice to keep it inline for core use, as it's called
> > > pretty often from the overflow path.
> > 
> > That's what I meant.
> > 
> > > A solution is to have a perf_output_copy_inline() in internal.h
> > > and export it through perf_output_copy() in buffer.c 
> > 
> > If only "external inline" would work :-)
> > 
> > I'd call it __perf_output_copy() though, less typing.
> 
> Just __output_copy() please - if someone is looking at kernel/events/*.c then 
> it's pretty clear that it's related to perf.
> 
> I.e. non-exposed symbols should lose their perf_ prefixes.

Agreed, I'm fixing that.


> 
> Thanks,
> 
> 	Ingo
