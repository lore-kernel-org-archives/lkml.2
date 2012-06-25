Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab2FYUn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:43:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52161 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2FYUn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:43:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/12] kmap_atomic cleanup for 3.6
Date: Mon, 25 Jun 2012 20:43:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        dhowells <dhowells@redhat.com>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com> <201206251518.08791.arnd@arndb.de> <1340645735.18025.88.camel@twins>
In-Reply-To: <1340645735.18025.88.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206252043.53231.arnd@arndb.de>
X-Provags-ID: V02:K0:uQ4DK6KcCKNZj93R54suzUdY3OD0twbxvSu7LZjxF2D
 cMHMfG0ANKHtK0Cdsqxou19EoWbrT81HtBKsK6qTaNDnT0m0Ji
 hMUfkt/yrZYRrtkDDq6kNW5TXrYFDAcVHNjwXZ7RwTScFTx3cc
 2S7TW6zW99yf2lcaABzi3sR57XveHmEgu+mGZIjtEvwL6p/tMT
 TZ04SEON94WvDgY99CSzRBFKJ0DDlyzFaQa3ywCnbA4pESkEYU
 a8vw6BFyuNUbTxs+or7+KwCW3QhSCRzwjknuyXm4Utk7zpH0HT
 RJBAJQDWFl0/s+9tlIm9O0Yccw+DxJbellwbf7j+PCoPqHIfcH
 0ZVWRNknoCbotEt4UlQo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 June 2012, Peter Zijlstra wrote:
> 
> On Mon, 2012-06-25 at 15:18 +0000, Arnd Bergmann wrote:
> > > Different arch has different values for KM_TYPE_NR, I am not sure if
> > > unifying them to a fixed value could fit all? 
> 
> No you can't. Some arch's have arch specific KM_TYPE thingies, like FRV.

Ah, right. Is it only FRV or are there any others?

> > > For safety, I kept their original values.
> > 
> > My fear is that it will make it harder to clean that code up for
> > real, when there is no longer an indication about where the number
> > comes from.
> 
> Agreed, I'd much prefer it if we'd come up with a sane way to compute
> the max value before doing away with these enums.
> 
> Sadly I haven't been able to come up with a sane way short of whole
> program analysis.

How about putting that constant into asm/highmem.h then, and adding a
default like

#ifndef KM_TYPE_NR
#define KM_TYPE_NR 8
#endif

in linux/highmem.h? Then FRV and anything else that needs it can override
the value and the other ones don't need to bother.

	Arnd
