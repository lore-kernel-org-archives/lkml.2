Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0F3Lyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 07:54:31 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:44970 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab0F3Lya convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Wed, 30 Jun 2010 07:54:30 -0400
Message-Id: <4C2B4CB10200007800008CDE@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 12:54:57 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Ky Srinivasan" <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 1/4, v2] x86: enlightenment for ticket spin locks -
	 base implementation
References: <4C2A1FE902000078000089E1@vpn.id2.novell.com>
 <1277885133.1868.71.camel@laptop>
 <4C2B23CD0200007800008BFA@vpn.id2.novell.com>
 <1277889116.1868.95.camel@laptop> <4C2B14BE.6080505@goop.org>
 <4C2B4A100200007800008CC5@vpn.id2.novell.com>
 <1277898525.1868.108.camel@laptop>
In-Reply-To: <1277898525.1868.108.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.06.10 at 13:48, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-06-30 at 12:43 +0100, Jan Beulich wrote:
> 
>> It does tickle just the new owner - that's what the list is for.
> 
> But if you have a FIFO list you don't need the ticket stuff and can
> implement a FIFO lock instead.

The list is LIFO (not FIFO, as only the most recently added entry is
a candidate for needing wakeup as long as there's no interrupt
re-enabling in irqsave lock paths), and is only used for tickling (not
for deciding who's going to be the next owner).

Jan

