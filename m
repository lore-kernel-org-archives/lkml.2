Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab0KZQgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:36:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:43155 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab0KZQgC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:36:02 -0500
Subject: Re: mlock'ed pages are paging out to shared mapped files?
From: Peter Zijlstra <peterz@infradead.org>
To: Bob Walters <bob.s.walters@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <03A305FE-2E9E-42B0-A06C-564E03295B2A@gmail.com>
References: <03A305FE-2E9E-42B0-A06C-564E03295B2A@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 26 Nov 2010 17:36:21 +0100
Message-ID: <1290789381.2145.154.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 11:25 -0500, Bob Walters wrote:
> 
> Please CC directly, I'm not subscribed.
> 
> I'm writing to determine if observed mlock behavior is a bug or the
> intended implementation.   The kernel seems to be paging out
> modifications made to locked pages of a shared (MAP_SHARED) memory
> mapped regular file, on Linux 2.6.35.6-48 (Fedora 14 distro, x86_64).
> Man pages implies that this might be a bug.   I have a repeatable
> process involving the following test: 

That's not paged-out, its a shared mapping (ie a mapped file), you dirty
the pages, we clean them by writing them out to disk.

That is the expected behaviour, if the man-page implies anything else
its bonkers.
