Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab0F3ILi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:11:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:36238 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab0F3ILg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:11:36 -0400
Subject: Re: [PATCH 4/4, v2] x86: enlightenment for ticket spin locks -
 improve yield behavior on Xen
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       jeremy.fitzhardinge@citrix.com, Ky Srinivasan <KSrinivasan@novell.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4C2A20E30200007800008A17@vpn.id2.novell.com>
References: <4C2A20E30200007800008A17@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Jun 2010 10:11:25 +0200
Message-ID: <1277885485.1868.74.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 15:35 +0100, Jan Beulich wrote:
> 
> The (only) additional overhead this introduces for native execution is
> the writing of the owning CPU in the lock acquire paths. 

Uhm, and growing the size of spinlock_t to 6 (or 8 bytes when aligned)
bytes when NR_CPUS>256.
