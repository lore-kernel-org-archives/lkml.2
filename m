Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab2BYXK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 18:10:27 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:59158 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756996Ab2BYXK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 18:10:26 -0500
Date: Sat, 25 Feb 2012 23:10:25 +0000
From: Eric Wong <normalperson@yhbt.net>
To: =?utf-8?Q?P=C3=A1draig?= Brady <P@draigBrady.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fadvise: avoid EINVAL if user input is valid
Message-ID: <20120225231025.GA20598@dcvr.yhbt.net>
References: <20120225022710.GA29455@dcvr.yhbt.net>
 <4F496715.7070005@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F496715.7070005@draigBrady.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pádraig Brady <P@draigBrady.com> wrote:
> On 02/25/2012 02:27 AM, Eric Wong wrote:
> > +		force_page_cache_readahead(mapping, file, start_index, nrpages);
> >  		break;
> 
> This whole patch makes sense to me.
> The above chunk might cause confusion in future,
> if people wonder for a moment why the return is ignored.
> Should you use cast with (void) like this to be explicit?
> 
> (void) force_page_cache_readahead(...);

I considered this, too[1].  However I checked for existing usages of
force_page_cache_readahead() noticed they just ignore the return value
like I did in my patch, so I followed existing convention for this
function.   I didn't find any suggestion in Documentation/CodingStyle
for this.

Thanks for looking at this.

[1] - it's what I normally do in my own projects.
