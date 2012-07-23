Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab2GWXaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 19:30:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab2GWXaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 19:30:22 -0400
Date: Mon, 23 Jul 2012 16:30:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Alex Shi <alex.shu@intel.com>,
        Jan Beulich <jbeulich@novell.com>,
        Robert Richter <robert.richter@amd.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 0/6] Avoid cache trashing on clearing huge/gigantic
 page
Message-Id: <20120723163020.5250e09e.akpm@linux-foundation.org>
In-Reply-To: <1342788622-10290-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1342788622-10290-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2012 15:50:16 +0300
"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> Clearing a 2MB huge page will typically blow away several levels of CPU
> caches.  To avoid this only cache clear the 4K area around the fault
> address and use a cache avoiding clears for the rest of the 2MB area.
> 
> It would be nice to test the patchset with more workloads. Especially if
> you see performance regression with THP.
> 
> Any feedback is appreciated.

This all looks pretty sane to me.  Some detail-poking from the x86 guys
would be nice.

What do other architectures need to do?  Simply implement
clear_page_nocache()?  I believe that powerpc is one, not sure about
others.  Please update the changelogs to let arch maintainers know
what they should do and cc those people on future versions?

