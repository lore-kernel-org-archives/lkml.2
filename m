Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992565Ab2KOB3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 20:29:37 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37381 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab2KOB3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 20:29:35 -0500
Date: Wed, 14 Nov 2012 17:29:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <rdunlap@infradead.org>
cc: Rafael Aquini <aquini@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-mm@kvack.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm: balloon_compaction.c needs asm-generic/bug.h
In-Reply-To: <50A43E64.3040709@infradead.org>
Message-ID: <alpine.DEB.2.00.1211141729050.4749@chino.kir.corp.google.com>
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au> <50A43E64.3040709@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Randy Dunlap wrote:

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build when CONFIG_BUG is not enabled by adding header file
> <asm-generic/bug.h>:
> 
> mm/balloon_compaction.c: In function 'balloon_page_putback':
> mm/balloon_compaction.c:243:3: error: implicit declaration of function '__WARN'
> 

This is fixed by 
mm-introduce-a-common-interface-for-balloon-pages-mobility-fix-fix-fix.patch 
in -mm which converts it to WARN_ON(1) which is the generic way to trigger 
a warning.
