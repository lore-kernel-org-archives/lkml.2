Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab0IMVuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:50:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab0IMVuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:50:08 -0400
Date: Mon, 13 Sep 2010 17:47:21 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Sembera <jsembera@suse.cz>, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, ink@jurassic.park.msu.ru, stable@kernel.org,
        linux-ia64@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] binfmt_misc: Fix binfmt_misc priority
Message-ID: <20100913174721.5fb57678@katamari>
In-Reply-To: <20100903142003.b6f02a0c.akpm@linux-foundation.org>
References: <20100823141520.GB17894@alaris.suse.cz>
	<20100903142003.b6f02a0c.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010 14:20:03 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 23 Aug 2010 16:15:20 +0200
> Jan Sembera <jsembera@suse.cz> wrote:
> 
> > Commit 74641f584da introduced a regression - binfmt_misc is now consulted
> > after binfmt_elf, which will unfortunately break ia32el. ia32 ELF binaries
> > on ia64 used to be matched using binfmt_misc and executed using wrapper. As
> > 32bit binaries are now matched by binfmt_elf before bindmt_misc kicks in,
> > the wrapper is ignored.

> Yikes, 74641f584da was merged in May 2009.  I wonder why this problem
> wasn't noticed before now?

I posted about this on Sep 15, 2009:

http://marc.info/?l=linux-kernel&m=125298891709482&w=4
"binfmt_misc takes precedence over binfmt_script in 2.6.30"

I also copied the author of the original patch, but there was no reply.
