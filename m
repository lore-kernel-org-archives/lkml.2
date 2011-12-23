Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab1LWJ26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:28:58 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:57592 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1LWJ24 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 23 Dec 2011 04:28:56 -0500
Message-Id: <4EF4581C0200007800069BA2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 23 Dec 2011 09:29:48 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <cl@linux.com>
Cc: <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: irqsafe_cpu_...() 64-bit operations on 32-bit platform
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

you introduced these for 2.6.33, but I wonder about their completeness
in the current state: On ix86, I can add, sub, xor, etc a 64-bit variable
this way (through the generic implementation), but there's no way to
read or write such a variable. While not documented explicitly, it seems
like the assumption is that this_cpu_{read,write}() can be used for this
purpose, but that's clearly wrong.

Along the same lines, Ingo, x86 has set_64bit() but no get_64bit()
(and no [gs]et_64bit_local()). Is that really intentional?

Thanks for your thoughts on this,
Jan

