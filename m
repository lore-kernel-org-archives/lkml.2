Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab1JSA4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 20:56:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55253 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab1JSA4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 20:56:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=ppNGGI5RvFP3Sk+qXVdER0iqp2fV2eKMlpYlgX1vVQCWd/w8ki1sQ2wsOxJLc8a0v
	V03x3DpZiXnswG/1goY7Q==
Date: Tue, 18 Oct 2011 17:56:23 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: munlock use mapcount to avoid terrible overhead
In-Reply-To: <20111018171453.53075590.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1110181752440.4283@sister.anvils>
References: <alpine.LSU.2.00.1110181700400.3361@sister.anvils> <20111018171453.53075590.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Andrew Morton wrote:
> On Tue, 18 Oct 2011 17:02:56 -0700 (PDT)
> Hugh Dickins <hughd@google.com> wrote:
> 
> > A process spent 30 minutes exiting, just munlocking the pages of a large
> > anonymous area that had been alternately mprotected into page-sized vmas:
> > for every single page there's an anon_vma walk through all the other
> > little vmas to find the right one.
> 
> And how long did the test case take with the patch applied?

5 seconds in the case tried; but the issue is quadratic,
so you can make the improvement look arbitrarily good.

Hugh
