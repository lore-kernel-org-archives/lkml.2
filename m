Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1HPGVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 02:21:21 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57104 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab1HPGVM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:8:1>);
	Tue, 16 Aug 2011 02:21:12 -0400
Message-Id: <4E4A28AE0200007800051605@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 16 Aug 2011 07:22:06 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Matt Fleming" <matt@console-pimps.org>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
        "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        <hpa@linux.intel.com>, "Avi Kivity" <avi@redhat.com>, <mjg@redhat.com>,
        "MarceloTosatti" <mtosatti@redhat.com>,
        "johnstultz" <johnstul@us.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
References: <4E3C30C602000078000740D5@nat28.tlf.novell.com>
 <1312810836.10579.127.camel@mfleming-mobl1.ger.corp.intel.com>
 <4E4009A50200007800050258@nat28.tlf.novell.com>
 <20110810090330.GF26762@elte.hu>
 <4E426D4702000078000508B5@nat28.tlf.novell.com>
 <20110810095140.GB21059@elte.hu>
 <4E429FE30200007800050910@nat28.tlf.novell.com>
 <1313432283.3436.110.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1313432283.3436.110.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.08.11 at 20:18, Matt Fleming <matt@console-pimps.org> wrote:
> On Wed, 2011-08-10 at 14:12 +0100, Jan Beulich wrote:
>> Bottom line - the fix here is needed for 32-bit booting only (and
>> hence isn't - afaic - as critical as I first thought). But the adjustment
>> I'm holding is a necessary one (and I don't even understand why,
>> when 32- and 64-bit EFI code got merged, this was left 32-bit only),
>> and the NX consolidation change needs to be fixed too (basically as
>> a prerequisite).
> 
> But the rtc-lock patch is independent and can be merged on its own,
> right? Sure the other issues need fixing but there's no sense in holding
> up the rtc-lock patch, since with it applied my machine actually boots.

Oh, yes, absolutely - I'm actually waiting for this one to get applied so
that the enabling of the use of the EFI RTC routines on x86-64 won't
cause the same problem there.

Jan

