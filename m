Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab2LNH17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 02:27:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52153 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2LNH17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 02:27:59 -0500
Date: Fri, 14 Dec 2012 07:27:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, J??rn Engel <joern@logfs.org>
Subject: Re: [PATCH] mm: Downgrade mmap_sem before locking or populating on
 mmap
Message-ID: <20121214072755.GR4939@ZenIV.linux.org.uk>
References: <3b624af48f4ba4affd78466b73b6afe0e2f66549.1355463438.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b624af48f4ba4affd78466b73b6afe0e2f66549.1355463438.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 09:49:43PM -0800, Andy Lutomirski wrote:
> This is a serious cause of mmap_sem contention.  MAP_POPULATE
> and MCL_FUTURE, in particular, are disastrous in multithreaded programs.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
> 
> Sensible people use anonymous mappings.  I write kernel patches :)
> 
> I'm not entirely thrilled by the aesthetics of this patch.  The MAP_POPULATE case
> could also be improved by doing it without any lock at all.  This is still a big
> improvement, though.

Wait a minute.  get_user_pages() relies on ->mmap_sem being held.  Unless
I'm seriously misreading your patch it removes that protection.  And yes,
I'm aware of execve-related exception; it's in special circumstances -
bprm->mm is guaranteed to be not shared (and we need to rearchitect that
area anyway, but that's a separate story).
