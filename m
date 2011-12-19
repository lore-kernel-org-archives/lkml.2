Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1LSSeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 13:34:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:52386 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab1LSSeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 13:34:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="88171434"
Message-ID: <4EEF83AD.4010800@linux.intel.com>
Date: Mon, 19 Dec 2011 10:34:21 -0800
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: holzheu@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic: Don't print redundant backtraces on oops
References: <1323304603-27895-1-git-send-email-andi@firstfloor.org>	 <20111216165207.cc75af5c.akpm@linux-foundation.org> <1324303755.2726.4.camel@br98xy6r>
In-Reply-To: <1324303755.2726.4.camel@br98xy6r>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


it?

> I think the two problems are not related. My problem was that only one
> CPU should execute panic. Andi's problem is that one (or more oops)
> messages are scrolled away by a subsequent panic.

Yes it's just for making panic less chatty.

> But I am not sure if Andi's patch solves all his problems. What e.g.
> about panic_on_oom? Don't we have the same problem here?

Yes, it only solves it for this specific -- but common -- case. Or at 
least it was a case
that annoyed me and prompted me to write the patch :)

I had a patch some time ago for a xpanic() where the caller could pass 
in additional
flags, including one to disable the backtrace. But that was a much 
larger patch,
this was a simpler alternative.

-Andi

