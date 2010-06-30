Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0F3NVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:21:09 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:33089 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab0F3NVI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Wed, 30 Jun 2010 09:21:08 -0400
Message-Id: <4C2B60FE0200007800008D3B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 14:21:34 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "Peter Zijlstra" <peterz@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Ky Srinivasan" <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 1/4, v2] x86: enlightenment for ticket spin locks -
	 base implementation
References: <4C2A1FE902000078000089E1@vpn.id2.novell.com>
 <1277885133.1868.71.camel@laptop>
 <4C2B23CD0200007800008BFA@vpn.id2.novell.com>
 <1277889116.1868.95.camel@laptop> <4C2B2180.6040401@goop.org>
 <4C2B4C050200007800008CDB@vpn.id2.novell.com> <4C2B3E42.1070808@goop.org>
In-Reply-To: <4C2B3E42.1070808@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.06.10 at 14:53, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 06/30/2010 01:52 PM, Jan Beulich wrote:
>> I fail to see that: Depending on the hypervisor's capabilities, the
>> two main functions could be much smaller (potentially there wouldn't
>> even be a need for the unlock hook in some cases),
> 
> What mechanism are you envisaging in that case?

A simple yield is better than not doing anything at all.

>> The list really juts is needed to not pointlessly tickle CPUs that
>> won't own the just released lock next anyway (or would own
>> it, but meanwhile went for another one where they also decided
>> to go into polling mode).
> 
> Did you measure that it was a particularly common case which was worth
> optimising for?

I didn't measure this particular case. But since the main problem
with ticket locks is when (host) CPUs are overcommitted, it
certainly is a bad idea to create even more load on the host than
there already is (the more that these are bursts).

Jan

