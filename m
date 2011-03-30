Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab1C3Oxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:53:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40952 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab1C3Oxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f/nuJpW1XaNZCp6QRoddg4ISUQDq9U5GHENUXw5QDO8+MJLcKgSgvM/p7ZH39dd6eF
         XnbkWOmFQdmo+1xg/hOUvtFrsceZPKXIr2gYAXOBeXOsit6+ZnEE2wakaRaV4VPhfx/g
         3sU5urBVJhHWR3d1YmCHXhymVIwQmBlOun74o=
Date: Wed, 30 Mar 2011 16:53:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Stable <stable@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: Rebase max unprivileged mlock threshold on top
 of page size
Message-ID: <20110330145324.GB2204@nowhere>
References: <1301065512.2250.223.camel@laptop>
 <1301493870-4551-1-git-send-email-fweisbec@gmail.com>
 <1301496028.4859.183.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301496028.4859.183.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 04:40:28PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-03-30 at 16:04 +0200, Frederic Weisbecker wrote:
> > +int sysctl_perf_event_mlock __read_mostly = (129 * PAGE_SIZE) / 1024; /* 'free' kb per user */
> 
> I'm fairly sure you don't want to do this either: 
>   512 + (PAGE_SIZE / 1024)
> should do I think, there's no reason to further inflate things for large
> page platforms.

Right, that also requires to fix tools that use a default number of pages instead
of computing nr_pages on top of page size and a default kb size.

Will respin by fixing both sides.

Thanks.
