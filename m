Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab2CaRBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 13:01:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54684 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab2CaRBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 13:01:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120331092915.19920.14205.stgit@zurg>
References: <20120331091049.19373.28994.stgit@zurg> <20120331092915.19920.14205.stgit@zurg>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 31 Mar 2012 10:01:08 -0700
X-Google-Sender-Auth: G89Uir2yCtT98_o75OiyviPGSjw
Message-ID: <CA+55aFwsmREkwBHuP_atBm7FJ76J=WjDj8aQsne85gbX9Sk19w@mail.gmail.com>
Subject: Re: [PATCH 3/7] mm: kill vma flag VM_CAN_NONLINEAR
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
        Ingo Molnar <mingo@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 2:29 AM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> This patch moves actual ptes filling for non-linear file mappings
> into special vma operation: ->remap_pages().
>
> Now fs must implement this method to get non-linear mappings support.
> If fs uses filemap_fault() then it can use generic_file_remap_pages() for this.

Me likee.

The other patches in the series look ok too, but this one in
particular is definitely the right thing, and an example of how people
have just used vm_flags bits for all the wrong reasons.

                  Linus
