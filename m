Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2CLMKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:10:33 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:59618 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab2CLMKb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 12 Mar 2012 08:10:31 -0400
Message-Id: <4F5DF5C30200007800077A5B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 12 Mar 2012 12:10:27 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: <mingo@elte.hu>, "Peter Zijlstra" <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: recent x86-64 nested NMI adjustments
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

the explanation of 45d5a1683c04be28abdf5c04c27b1417e0374486
seems bogus to me: When arriving from user mode, %rsp won't point
to the user stack anymore, as it gets switched away from during the
processing of the exception (the more that the IDT entry specifies a
separate stack anyway, which even guarantees this for kernel mode
entries).

Further, a38449ef596b345e13a8f9b7d5cd9fedb8fcf921 makes the
(presumably superfluous) compare a 4-byte one, while the
documentation isn't really stating that selectors get pushed zero-
extended. Hence, if not reverting the first change altogether, I'd
minimally recommend converting the compare to a 2-byte one.

Jan

