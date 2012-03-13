Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab2CMO0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 10:26:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982Ab2CMO0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 10:26:50 -0400
Date: Tue, 13 Mar 2012 10:26:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: CAI Qian <caiqian@redhat.com>, Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: crash dump memory reservation regression
Message-ID: <20120313142624.GE29169@redhat.com>
References: <5535e246-b7c0-4f69-a27b-1abbadd42db0@zmail14.collab.prod.int.phx2.redhat.com>
 <65a23329-d843-4859-8b7b-430f12882492@zmail14.collab.prod.int.phx2.redhat.com>
 <CAE9FiQU9C=5YAa3DPcx8E9yVckSX5JbLdS=TC90jA8wz1pjzmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQU9C=5YAa3DPcx8E9yVckSX5JbLdS=TC90jA8wz1pjzmw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 10:31:21PM -0700, Yinghai Lu wrote:

[..]
> 3.  fix kdump, and make kdump could take two ranges, one is small
> segment below 512M, other part could be more than 4G.

I will prefer to avoid supporting split memory range for kdump memory.
This will make the kdump solution complicated and we might not have
much to gain.

In general focus is to reserve as less a memory as possible for kdump
kernel. Currently for x86, we reserve 128M adhoc block by default and
scale it up by 64MB per 1TB of physical RAM (dump filtering utility
requires 2bits of memory per 4K physical page).

So as long as we can reserve till 512MB of kdump memory, that should allow
us to support up to 6TB of systems with dump filtering. Hopefully that is
sufficient for quite some time and we don't have to take the path of
supporting non-contiguous memory for kdump.

Thanks
Vivek
