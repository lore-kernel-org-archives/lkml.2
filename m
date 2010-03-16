Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab0CPWZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 18:25:25 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:51690 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab0CPWZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 18:25:22 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALChn0urR7H+/2dsb2JhbACbBHOhY5h0hHYEgxo
X-IronPort-AV: E=Sophos;i="4.49,653,1262563200"; 
   d="scan'208";a="497710845"
From: Roland Dreier <rdreier@cisco.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kfifo:  possible weird violation of what should be invariant
References: <alpine.LFD.2.00.1003151702040.3329@localhost>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 16 Mar 2010 15:25:17 -0700
In-Reply-To: <alpine.LFD.2.00.1003151702040.3329@localhost> (Robert
	P. J. Day's message of "Mon, 15 Mar 2010 17:22:49 -0400 (EDT)")
Message-ID: <adamxy79a5u.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >   sure, the code seems to work, but allowing the internal values of a
 > kfifo to contain invalid values on a regular basis would seem to make
 > a mess of, say, tracing or debugging.  making sure that offset values
 > actually lie within their valid range would seem to be one of those
 > ASSERT() things that should always be true, should it not?  is there a
 > reason the design is like this?

Actually I believe having the values be free-running without clamping
them makes the code much simpler -- the reason being that you preserve
the invariant of "in" always being ahead of "out".  If you reduce the
pointers modulo the size, then you end up having a lot of code that has
two cases: one to handle "in > out", and one to handle "in < out because
in has wrapped and out hasn't yet".

 - R.
-- 
Roland Dreier  <rolandd@cisco.com>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
