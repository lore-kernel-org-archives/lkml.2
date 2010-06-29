Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab0F2OaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 10:30:00 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39616 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab0F2O37 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Tue, 29 Jun 2010 10:29:59 -0400
Message-Id: <4C2A1F9F02000078000089DE@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 29 Jun 2010 15:30:22 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <jeremy.fitzhardinge@citrix.com>, "Ky Srinivasan" <KSrinivasan@novell.com>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4, v2] x86: enlightenment for ticket spin locks
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the pv-ops based spinlocks reportedly having measurable overhead
on native execution, and with them also not easily fit (at least) fully
virtualized Xen guests, this patch series introduces a replacement
mechanism based on alternative instruction patching, and then uses it
for fully virtualized Xen guests. While coded to be orthogonal to
pv-ops, it really isn't, and it shouldn't be difficult to make pv-ops guests
use this in place of pv-ops spin locks.

The only additional overhead this introduces for native execution is
(in the optional fourth patch) the writing of the owning CPU in the
lock acquire paths. If this is considered a problem but the patch
otherwise is deemed useful, even that code could be eliminated for
native execution (by further alternative instruction patching).

(1) base implementation
(2) Xen implementation
(3) [optional] eliminate NOPs in unlock path (introduced in (1))
(4) [optional] improve behavior on Xen by yielding earlier in
    certain cases

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: KY Srinivasan <ksrinivasan@novell.com>

