Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab2GYSvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:51:09 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:47928 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750789Ab2GYSvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:51:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: .wIITOYVM1nUC06xgJ9sCrWDaGd99EpEHcde6oKJPlEy0L6
 biCEhHCy6rJlzhqCPwseZ8cbiwj4iiI.IXQFI8zGLVPKJTZntFHDg63mzaiP
 5.W6XphmmECbHj3BCFsk_wbieJvV235Zk7GyTaon.kVAAaAaJAF.4N6VQUPF
 43NBaIYJexWkC9Pr_Y1a..4IeYpJ9dHBa3VWn3wSVCSxHgUrKcysr1G8dZ4v
 1Gie2bIxxiEi_nx3v.j3Rx686x1z056ezM09PrqK3zSEJDh8XglVpD9qmdHQ
 DYLJ.EddAr9O7eEAkk8ZMNrZGD4RkO5775PeApPJuwIJmV7qtaVYLFGQ13nU
 n5D1FVDOpBFlWew94w0_8x40B9gn1RWbB0hXoWVvBlH8Dv2f0xHvx25blUKK
 SjWxMekyaLbwVWSNbTtfuCc2rIuGlKPbv.kN56D8E_LzfThfqwd_u
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 25 Jul 2012 13:51:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Alex Shi <alex.shu@intel.com>,
        Jan Beulich <jbeulich@novell.com>,
        Robert Richter <robert.richter@amd.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 0/6] Avoid cache trashing on clearing huge/gigantic
 page
In-Reply-To: <1342788622-10290-1-git-send-email-kirill.shutemov@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1207251346250.4995@router.home>
References: <1342788622-10290-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2012, Kirill A. Shutemov wrote:

> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> Clearing a 2MB huge page will typically blow away several levels of CPU
> caches.  To avoid this only cache clear the 4K area around the fault
> address and use a cache avoiding clears for the rest of the 2MB area.

why exempt the 4K around the fault address? Is there a regression if that
is not exempted?

I guess for anonymous huge pages one may assume that there will be at
least one write to one cache line in the 4k page. Is it useful to get all
the cachelines in the page in the cache.

Also note that if we get later into hugepage use for the page cache we
would want the cache to be cold because the contents have to come in from
a storage medium.


