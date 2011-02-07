Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab1BGLBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 06:01:13 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:58650 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab1BGLBM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Mon, 7 Feb 2011 06:01:12 -0500
Message-Id: <4D4FDF050200007800030883@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 07 Feb 2011 11:01:09 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <tj@kernel.org>, <cl@linux.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: x86: mis-named percpu_xchg_op() after switch to cmpxchg?
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other than its name implies, with the switch to use cmpxchg instead of
xchg (commit 8270137a0d50507a5b40f880db636527045b8466) this
macro is no longer suitable for accessing anything that may be written
by other than the local CPU (i.e. anything but the various this_cpu
accessors). Shouldn't it therefore get renamed to eg this_cpu_xchg_op()?

Jan

