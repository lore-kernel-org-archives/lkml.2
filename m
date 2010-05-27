Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072Ab0E0Ptx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:49:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36063 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0E0Ptv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:49:51 -0400
Date: Thu, 27 May 2010 11:49:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
Message-ID: <20100527154916.GA5585@infradead.org>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 05:37:36AM +0530, Jaswinder Singh Rajput wrote:
> Hello,
> 
> I am trying to build 32 bit kernel image on 64-bit machine but after
> 'make menuconfig' it automatically switches 32-bit to 64-bit.
> 
> Is this a BUG or did intentionally.

I think it's intentional, but I'm really annoyed by this behaviour.
I really don't want my config to change from a normal make depending
on uname output.  We do have a CONFIG_64BIT in .config which should
be respected.  uname output is a good indicator for a previously
unconfigured kernel, but shouldn't change settings for a fully
congigured build.  Forgetting the linux32 command happens at least two
dozen times to me everyday, leading to a few lost seconds that add
up in the end.

