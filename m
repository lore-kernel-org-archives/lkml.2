Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab1HGHjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 03:39:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55172 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1HGHjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 03:39:21 -0400
Date: Sun, 7 Aug 2011 09:39:16 +0200
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] stop_machine: build unconditionally if SMP
Message-ID: <20110807073916.GA13298@mtj.dyndns.org>
References: <1312614073-11516-1-git-send-email-rabin@rab.in>
 <20110806080323.GB23937@htj.dyndns.org>
 <20110806163837.881d70af.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110806163837.881d70af.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Aug 06, 2011 at 04:38:37PM -0700, Andrew Morton wrote:
> The priority is unclear.  It appears that the patch fixes a build error
> under sone circumstances in current mainline?

I don't think it would have triggered build error as there are dummy
functions which just calls the function on the local CPU, but it does
look pretty broken now.  e.g. ia64 supports memory hotplug which
depends on stop machine but it would still be using dummy local
version, which can't be right.

Robin, is there an open bug report regarding this issue?  I'm not sure
enough to suggest -stable but definitely mainline material.

Thanks.

-- 
tejun
