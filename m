Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab1KGN1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 08:27:40 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48587 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab1KGN1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 08:27:39 -0500
Date: Mon, 7 Nov 2011 21:26:02 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 4/4] lockdep: fix race condition in
 __lock_set_class()
Message-ID: <20111107132602.GA2783@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
 <1320398790-21663-5-git-send-email-yong.zhang0@gmail.com>
 <1320669054.18053.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1320669054.18053.25.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 01:30:54PM +0100, Peter Zijlstra wrote:
> On Fri, 2011-11-04 at 17:26 +0800, Yong Zhang wrote:
> > When someone call lock_set_class() with valid key, nothing
> > protect the initializing of 'lockdep_map'; thus could lead
> > to flase positive warning from lockdep (such as "key not in
> > .data!"). This patch cure that potential issue.
> 
> How? that warning is triggered of the lock_class_key * passed into
> lockdep_init_map and is unrelated to the actual content of the
> lockdep_map.

Oh, my fault, the false positive warning could be "non-static key".

But seems we should find the right direction for this bug :)
Some comments in replies to patch#1.

Thanks,
Yong
