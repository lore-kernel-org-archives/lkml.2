Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3ACG06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:26:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab3ACG05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:26:57 -0500
Message-ID: <50E52316.6010602@redhat.com>
Date: Thu, 03 Jan 2013 01:20:06 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Jorn_Engel <joern@logfs.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] mm: introduce VM_POPULATE flag to better deal with
 racy userspace programs
References: <1356050997-2688-1-git-send-email-walken@google.com> <1356050997-2688-10-git-send-email-walken@google.com>
In-Reply-To: <1356050997-2688-10-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 07:49 PM, Michel Lespinasse wrote:
> The vm_populate() code populates user mappings without constantly
> holding the mmap_sem. This makes it susceptible to racy userspace
> programs: the user mappings may change while vm_populate() is running,
> and in this case vm_populate() may end up populating the new mapping
> instead of the old one.
>
> In order to reduce the possibility of userspace getting surprised by
> this behavior, this change introduces the VM_POPULATE vma flag which
> gets set on vmas we want vm_populate() to work on. This way
> vm_populate() may still end up populating the new mapping after such a
> race, but only if the new mapping is also one that the user has
> requested (using MAP_SHARED, MAP_LOCKED or mlock) to be populated.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Acked-by: Rik van Riel <ri

-- 
All rights reversed
