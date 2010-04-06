Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab0DFGHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 02:07:33 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:12057 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757113Ab0DFGH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 02:07:28 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGJsukurR7Hu/2dsb2JhbACbTXGebJhrhQcEgyQ
X-IronPort-AV: E=Sophos;i="4.51,370,1267401600"; 
   d="scan'208";a="110658980"
From: Roland Dreier <rdreier@cisco.com>
To: =?utf-8?B?5p2o56GV?= <shanqn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: in x86 architecture ,why the function atomic_sub_and_test() does not  disable the interrupt?
References: <u2mffe582101004052213zb2e4ec2dp110b8177c04f300e@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 05 Apr 2010 23:07:24 -0700
In-Reply-To: <u2mffe582101004052213zb2e4ec2dp110b8177c04f300e@mail.gmail.com>
	(=?utf-8?B?IuadqOehlSIncw==?= message of "Tue, 6 Apr 2010 13:13:57 +0800")
Message-ID: <adahbnp6rmr.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > static inline int atomic_sub_and_test(int i, atomic_t *v)
 > {
 > 	unsigned char c;
 > 
 > 	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
 > 		     : "+m" (v->counter), "=qm" (c)
 > 		     : "ir" (i) : "memory");
 > 	return c;
 > }

Why would disabling interrupts be necessary?  The LOCK_PREFIX makes the
subl atomic, and the sete just operates using the flag set by subl, so
it doesn't matter if any interrupts occur or not (since returning from
an interrupt must obviously restore flags).
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
