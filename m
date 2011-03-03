Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab1CCJsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 04:48:08 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:54972 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1CCJsG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Thu, 3 Mar 2011 04:48:06 -0500
Message-Id: <4D6F6C660200007800034AD2@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 03 Mar 2011 09:24:38 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Shaohua Li" <shaohua.li@intel.com>,
        "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [tip:x86/mm] x86: Work around old gas bug
References: <201103012352.p21NqRN1006974@imap1.linux-foundation.org>
 <tip-253d89d3dd6b65595f317e5f1ecef43aa207a3a0@git.kernel.org>
 <4D6E2B8B02000078000347C0@vpn.id2.novell.com>
 <20110302104144.GB25608@elte.hu>
 <20110302082453.934f2033.akpm@linux-foundation.org>
 <1299130025.19589.89.camel@sli10-conroe>
 <20110302213553.88ec33cd.akpm@linux-foundation.org>
In-Reply-To: <20110302213553.88ec33cd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.03.11 at 06:35, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 03 Mar 2011 13:27:05 +0800 Shaohua Li <shaohua.li@intel.com> wrote:
> 
>> On Thu, 2011-03-03 at 00:24 +0800, Andrew Morton wrote:
>> > On Wed, 2 Mar 2011 11:41:44 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>> > 
>> > > Meanwhile, what i hate more than ugly code repetition is code that does 
> not build at 
>> > > all on akpm's test environment ;-)
>> > 
>> > I hadn't got around to testing it.  Bad news :(
>> > 
>> Andrew,
>> can you this on your side? this is what Jan proposed. I can only test a
>> latest binutils here.
> 
> Nope.
> 
> arch/x86/kernel/entry_64.S: Assembler messages:
> arch/x86/kernel/entry_64.S:985: Error: too many positional arguments

Indeed - the problem isn't with the actual assembly construct, but
rather with the changed definitions of *INVALIDATE_TLB_VECTOR* -
properly parenthesizing them (as we needed to do in other places)
and removing unnecessary spaces gets this to build for me, even 
with the original use of .irp instead of .irpc:

#if NR_CPUS <= 32
# define NUM_INVALIDATE_TLB_VECTORS (NR_CPUS)
#else
# define NUM_INVALIDATE_TLB_VECTORS (32)
#endif

#define INVALIDATE_TLB_VECTOR_END	(0xee)
#define INVALIDATE_TLB_VECTOR_START	\
	(INVALIDATE_TLB_VECTOR_END-NUM_INVALIDATE_TLB_VECTORS+1)

Jan

