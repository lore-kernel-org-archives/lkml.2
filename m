Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab2E3PON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:14:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab2E3POL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:14:11 -0400
Message-ID: <4FC6393B.7090105@draigBrady.com>
Date: Wed, 30 May 2012 16:14:03 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC Patch] fs: implement per-file drop caches
References: <1338385120-14519-1-git-send-email-amwang@redhat.com>
In-Reply-To: <1338385120-14519-1-git-send-email-amwang@redhat.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 02:38 PM, Cong Wang wrote:
> This is a draft patch of implementing per-file drop caches.
> 
> It introduces a new fcntl command  F_DROP_CACHES to drop
> file caches of a specific file. The reason is that currently
> we only have a system-wide drop caches interface, it could
> cause system-wide performance down if we drop all page caches
> when we actually want to drop the caches of some huge file.

This is useful functionality.
Though isn't it already provided with POSIX_FADV_DONTNEED?

This functionality was added to GNU dd (8.11) a year ago:
http://git.sv.gnu.org/gitweb/?p=coreutils.git;a=commitdiff;h=5f31155

Here are the examples from that patch:

# Advise to drop cache for whole file
dd if=ifile iflag=nocache count=0

# Ensure drop cache for the whole file
dd of=ofile oflag=nocache conv=notrunc,fdatasync count=0

# Drop cache for part of file
dd if=ifile iflag=nocache skip=10 count=10 of=/dev/null

# Stream data using just the read-ahead cache
dd if=ifile of=ofile iflag=nocache oflag=nocache

cheers,
Pádraig.
