Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab0CXVxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:53:13 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:16944 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0CXVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:53:11 -0400
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABMnqkurR7H+/2dsb2JhbACbG3OnXpkQhH4Egx4
X-IronPort-AV: E=Sophos;i="4.51,303,1267401600"; 
   d="scan'208";a="247984247"
From: Roland Dreier <rdreier@cisco.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
References: <201003242240.54907.arnd@arndb.de>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 24 Mar 2010 14:53:07 -0700
In-Reply-To: <201003242240.54907.arnd@arndb.de> (Arnd Bergmann's message of
	"Wed, 24 Mar 2010 22:40:54 +0100")
Message-ID: <adavdclz8sc.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Interesting work.  For the drivers/infiniband part, it seems maybe all
these drivers should be using no_llseek instead of default_llseek?  (or
is it better style to use nonseekable_open()?)  Certainly as far as I
can tell, nothing in drivers/infiniband pays any attention to f_pos.

Also, is there a reason why you add "#include <linux/smp_lock.h>" to all
the files where you also do ".llseek  = default_llseek"?

In any case I can at least take care of the llseek stuff for 2.6.35.

 - R.
-- 
Roland Dreier  <rolandd@cisco.com>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
