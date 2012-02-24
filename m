Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab2BXKFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:05:30 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:37827 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab2BXKF2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:05:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.182.48.36 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1202240200380.24971@chino.kir.corp.google.com>
References: <20120222115320.GA3107@x61.redhat.com>
	<alpine.DEB.2.00.1202221640420.14213@chino.kir.corp.google.com>
	<20120223152226.GA2014@x61.redhat.com>
	<alpine.DEB.2.00.1202231509510.26362@chino.kir.corp.google.com>
	<alpine.LFD.2.02.1202240856370.1917@tux.localdomain>
	<alpine.DEB.2.00.1202240200380.24971@chino.kir.corp.google.com>
Date: Fri, 24 Feb 2012 12:05:27 +0200
X-Google-Sender-Auth: hhVzRI6wLD0wH8fOnw6HSzqr95A
Message-ID: <CAOJsxLExoyzvpRNOEdT3+x1mhSCZt0dO7NLKkpi7CrJ7HW2kpw@mail.gmail.com>
Subject: Re: [PATCH] oom: add sysctl to enable slab memory dump
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, Rik van Riel <riel@redhat.com>,
        Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 12:03 PM, David Rientjes <rientjes@google.com> wrote:
> I like how slub handles this when it can't allocate more slab with
> slab_out_of_memory() and has the added benefit of still warning even with
> __GFP_NORETRY that the oom killer is never called for.  If there's really
> a slab leak happening, there's a good chance that this diagnostic
> information is going to be emitted by the offending cache at some point in
> time if you're using slub.  This could easily be extended to slab.c, so
> it's even more reason not to include this type of information in the oom
> killer.

Works for me. Rafael?
