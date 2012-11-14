Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423488Ab2KNVdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 16:33:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423452Ab2KNVdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 16:33:44 -0500
Date: Wed, 14 Nov 2012 13:33:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 00/11] Introduce huge zero page
Message-Id: <20121114133342.cc7bcd6e.akpm@linux-foundation.org>
In-Reply-To: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Nov 2012 17:00:52 +0200
"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> Andrew, here's updated huge zero page patchset.

There is still a distinct lack of reviewed-by's and acked-by's on this
patchset.

On 13 Sep, Andrea did indicate that he "reviewed the whole patchset and
it looks fine to me".  But that information failed to make it into the
changelogs, which is bad.

I grabbed the patchset.  I might hold it over until 3.9 depending on
additional review/test feedback and upon whether Andrea can be
persuaded to take another look at it all.

I'm still a bit concerned over the possibility that some workloads will
cause a high-frequency free/alloc/memset cycle on that huge zero page. 
We'll see how it goes...

For this reason and for general ease-of-testing: can and should we add
a knob which will enable users to disable the feature at runtime?  That
way if it causes problems or if we suspect it's causing problems, we
can easily verify the theory and offer users a temporary fix.

Such a knob could be a boot-time option, but a post-boot /proc thing
would be much nicer.

