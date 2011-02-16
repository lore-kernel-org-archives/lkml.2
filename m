Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1BPXIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 18:08:18 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36160 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab1BPXIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 18:08:16 -0500
Subject: Re: [PATCH 0/4] IMA: making i_readcount a first class inode citizen
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>, torvalds@linux-foundation.org,
        eparis@redhat.com, viro@zeniv.linux.org.uk,
        Dave Chinner <david@fromorbit.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        David Safford <safford@watson.ibm.com>
In-Reply-To: <1297715397-4141-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1297715397-4141-1-git-send-email-zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 18:08:13 -0500
Message-ID: <1297897693.2524.201.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

As Linus has already agreed that the i_readcount patches (1 - 4) can be
upstreamed (https://lkml.org/lkml/2010/11/18/670), do I need to do
anything else (eg. send James a request to pull)?

thanks,

Mimi

On Mon, 2011-02-14 at 15:29 -0500, Mimi Zohar wrote:
> This is a repost of patches 1 - 4 of the ima-i_readcount patch set rebased
> against security-testing/#next, as requested a while ago.  The patches are
> also available from:
> git://git.kernel.org/pub/scm/linux/kernel/git/zohar/ima-2.6.git/#next
> 
> This patchset separates the incrementing/decrementing of the i_readcount,
> in the VFS layer, from other IMA functionality, by replacing the current
> ima_counts_get() call with i_readcount_inc(). Its unclear whether this
> call to increment i_readcount should be made earlier, like i_writecount.
> Currently the call is situated immediately after the switch from put_filp()
> to fput() for cleanup.
> 
> Mimi
> 
> Mimi Zohar (4):
>   IMA: convert i_readcount to atomic
>   IMA: define readcount functions
>   IMA: maintain i_readcount in the VFS layer
>   IMA: remove IMA imbalance checking
> 
>  fs/file_table.c                   |    5 +-
>  fs/open.c                         |    3 +-
>  include/linux/fs.h                |   23 ++++++-
>  include/linux/ima.h               |    6 --
>  security/integrity/ima/ima_iint.c |    5 --
>  security/integrity/ima/ima_main.c |  130 ++++---------------------------------
>  6 files changed, 40 insertions(+), 132 deletions(-)
> 


