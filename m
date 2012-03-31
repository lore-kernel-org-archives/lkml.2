Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2CaTsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 15:48:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47070 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab2CaTsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 15:48:19 -0400
MIME-Version: 1.0
In-Reply-To: <4F718007.4000401@jp.fujitsu.com>
References: <4F718007.4000401@jp.fujitsu.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sat, 31 Mar 2012 15:47:58 -0400
Message-ID: <CAOPLpQdQFibpWg32D5GxtLkOkhao+c19z635cQxzMepKktD=oA@mail.gmail.com>
Subject: Re: [RFC] [PATCH 1/2] binary stream format for /proc/stat
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/27 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> Provides another format of /proc/stat for showing data in binary and
> compress sequence of Zeros to some extent.
>
> Any other idea of formats ?

Not for the format.  /proc/stat will likely not be the only file to be
treated like this.  How abou an open() flag O_??? which indicates the
binary format is wanted?  Maybe re-purpose a flag which doesn't have a
meaning on those files (like, for instance, O_DIRECT).  Files which
don't support the format can fail to open with the flag set.  This way
all relevant files can be converted over time.
