Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab0F3ODK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:03:10 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:51705 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab0F3ODH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Wed, 30 Jun 2010 10:03:07 -0400
Message-Id: <4C2B6AD60200007800008D90@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 15:03:34 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
       "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Ky Srinivasan" <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 2/4, v2] x86: enlightenment for ticket spin locks -
	 Xen implementation
References: <4C2A200F02000078000089E4@vpn.id2.novell.com>
 <4C2B1769.5090107@goop.org> <4C2B47190200007800008CB7@vpn.id2.novell.com>
 <4C2B4564.7030203@goop.org>
In-Reply-To: <4C2B4564.7030203@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.06.10 at 15:23, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> For spinlocks, the pvop calls should only be in the slow case: when a
> spinlock has been spinning for long enough, and on unlock when there's
> someone waiting for the lock.  The fastpath (no contention lock and
> unlock) should have no extra calls.

Then what was all that performance regression noise concerning
pvops spinlocks about, leading to CONFIG_PARAVIRT_SPINLOCKS
being separated from the base CONFIG_PARAVIRT?

Afaics the unlock still involves a function call *in all cases* with
pvops spinlocks, whereas it's a single inline instruction without.

Jan

