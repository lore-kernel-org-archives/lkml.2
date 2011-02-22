Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab1BVOXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:23:00 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:34082 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab1BVOW6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:11:1>);
	Tue, 22 Feb 2011 09:22:58 -0500
Message-Id: <4D63D4CD020000780003320A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 22 Feb 2011 14:22:53 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Andrea Arcangeli" <aarcange@redhat.com>
Cc: "Ian Campbell" <Ian.Campbell@citrix.com>,
        "Andi Kleen" <andi@firstfloor.org>, "Hugh Dickins" <hughd@google.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Johannes Weiner" <jweiner@redhat.com>,
        "Larry Woodman" <lwoodman@redhat.com>,
        "Rik van Riel" <riel@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
References: <20110207232045.GJ3347@random.random>
 <20110215190710.GL5935@random.random>
 <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
 <20110215195450.GO5935@random.random>
 <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
 <20110216183304.GD5935@random.random> <20110217101941.GH2380@redhat.com>
 <20110221143023.GF13092@random.random> <20110221145350.GH25382@redhat.com>
 <4D6378760200007800033104@vpn.id2.novell.com>
 <20110222134956.GU13092@random.random>
In-Reply-To: <20110222134956.GU13092@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.02.11 at 14:49, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Tue, Feb 22, 2011 at 07:48:54AM +0000, Jan Beulich wrote:
>> A possible alternative would be to acquire the page table lock
>> in vmalloc_sync_all() only in the Xen case (perhaps by storing
>> NULL into page->index in pgd_set_mm() when not running on
>> Xen). This is utilizing the fact that there aren't (supposed to
>> be - for non-pvops this is definitely the case) any TLB flush IPIs
>> under Xen, and hence the race you're trying to fix doesn't
>> exist there (while non-Xen doesn't need the extra locking).
> 
> That's sure ok with me. Can we use a global runtime to check if the
> guest is running under Xen paravirt, instead of passing that info
> through page->something?

If everyone's okay with putting a couple of "if (xen_pv_domain())"
into mm/fault.c - sure. I would have thought that this wouldn't be
liked, hence the suggestion to make this depend on seeing the
backlink be non-NULL.

Jan

