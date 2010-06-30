Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0F3Lai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 07:30:38 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:52557 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab0F3Lah convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Wed, 30 Jun 2010 07:30:37 -0400
Message-Id: <4C2B47190200007800008CB7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 12:31:05 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
       "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Ky Srinivasan" <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 2/4, v2] x86: enlightenment for ticket spin locks -
	 Xen  implementation
References: <4C2A200F02000078000089E4@vpn.id2.novell.com>
 <4C2B1769.5090107@goop.org>
In-Reply-To: <4C2B1769.5090107@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.06.10 at 12:07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 06/29/2010 04:32 PM, Jan Beulich wrote:
>> Use the (alternative instructions based) callout hooks to the ticket
>> spinlock code to enlighten ticket locks when running fully virtualized
>> on Xen. Ultimately, this code might also be a candidate to be used
>> when running para-virtualized.
>>   
> 
> I'm not sure what the gain is by making this independent of all the rest
> of the Xen support in the kernel.  Stefano is working on a series
> (posted a few times now) to add more paravirtual features for Xen HVM
> guests, and this work is conceptually very similar.

The intention really is for PARAVIRT_SPINLOCKS to go away as soon
as pv-ops Xen can be switched over to this mechanism.

> Also, I'm not very keen on adding yet another kind of patching mechanism
> to the kernel.  While they're easy enough to get working in the first
> place, they do tend to be fragile when other changes get introduced
> (like changes to how the kernel is mapped RO/NX, etc), and this one will
> be exercised relatively rarely.  I don't see why the pvops mechanism
> couldn't be reused, especially now that each set of ops can be
> individually configured on/off.

Wasn't the main complaint with using pvops patching that it
introduced extra calls into the native execution path? The point
of this "new" (it's not really new, it's using existing infrastructure)
mechanism is just to avoid such overhead for native.

> This is especially acute in the case where you are using a full
> pvops-using PV kernel, where it ends up using two mechanisms to put
> paravirtualizations in place.

And I see nothing wrong with this - if the individual pieces are
separate anyway, why shouldn't each of them use the most
efficient technique? Or if a single mechanism is desirable, shouldn't
one rather ask to convert the newer pvops patching mechanism
to the alternative instruction patching one, as that had been in
place long before?

Jan

