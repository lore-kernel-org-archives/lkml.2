Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934156Ab1CYKNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:13:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58172 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab1CYKNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W7HbuCXPH1U/+6MKvvxfRYfHgXIeFN+Uf1xAitZm3M7In/6wnS+OAP7+H6olKsnFNz
         xLYtvb20aFooQxM/frmtlT2pYzOnHeEkjT9Oej3xGmuvB8xp5OCK+rHRzg9nQOZEXHRx
         ywarlpaiEn1TUH2YjKXZPHQlH27oinIQGjFhA=
Date: Fri, 25 Mar 2011 11:12:38 +0100
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Message-ID: <20110325101238.GC1409@htj.dyndns.org>
References: <20110323153727.GB12003@htj.dyndns.org>
 <20110324094119.GD12038@htj.dyndns.org>
 <20110324094151.GE12038@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324094151.GE12038@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 24, 2011 at 10:41:51AM +0100, Tejun Heo wrote:
>         USER   SYSTEM   SIRQ    CXTSW  THROUGHPUT
>  SIMPLE 61107  354977    217  8099529  845.100 MB/sec
>  SPIN   63140  364888    214  6840527  879.077 MB/sec
> 
> On various runs, the adaptive spinning trylock consistently posts
> higher throughput.  The amount of difference varies but it outperforms
> consistently.

I've been running more of these tests and am having doubts about the
consistency.  It seems that, even on a fresh filesystem, some random
initial condition seems to have persistent effect on the whole run.
I'll run more tests and report back.

Thanks.

-- 
tejun
