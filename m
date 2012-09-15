Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab2IOJ0E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 05:26:04 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43203 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab2IOJ0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 05:26:02 -0400
Message-ID: <505449BF.5040000@gmail.com>
Date: Sat, 15 Sep 2012 11:26:23 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120902 Thunderbird/15.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-mm@kvack.org, riel@redhat.com, peterz@infradead.org,
        aarcange@redhat.com, hughd@google.com, daniel.santos@pobox.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Dave Jones <davej@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 6/7] mm: add CONFIG_DEBUG_VM_RB build option
References: <1346750457-12385-1-git-send-email-walken@google.com> <1346750457-12385-7-git-send-email-walken@google.com> <5053AC2F.3070203@gmail.com> <CANN689Ff3W4z=+3J8aGO-2GrPHGJ=ote_f5q9jzRQRAP+b0T4Q@mail.gmail.com> <20120915000029.GA29426@google.com>
In-Reply-To: <20120915000029.GA29426@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2012 02:00 AM, Michel Lespinasse wrote:
> All right. Hugh managed to reproduce the issue on his suse laptop, and
> I came up with a fix.
> 
> The problem was that in mremap, the new vma's vm_{start,end,pgoff}
> fields need to be updated before calling anon_vma_clone() so that the
> new vma will be properly indexed.
> 
> Patch attached. I expect this should also explain Jiri's reported
> failure involving splitting THP pages during mremap(), even though we
> did not manage to reproduce that one.

Initially I've stumbled on it by running trinity inside a KVM tools guest. fwiw,
the guest is pretty custom and isn't based on suse.

I re-ran tests with patch applied and looks like it fixed the issue, I haven't
seen the warnings even though it runs for quite a while now.


Thanks,
Sasha
