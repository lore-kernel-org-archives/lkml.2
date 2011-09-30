Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab1I3VQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 17:16:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:31381 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab1I3VQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 17:16:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=HFj2e/IeHcft8mS8vgW0c4St+wJQ3LaqvC2LWcAWBGZjoQt9lU8rBGnafAUZq4ieR
	3VjxQobl6/quWSMtI3nQA==
MIME-Version: 1.0
In-Reply-To: <20110930181914.GA17817@mgebm.net>
References: <1317170947-17074-1-git-send-email-walken@google.com>
	<20110929164319.GA3509@mgebm.net>
	<CANN689H1G-USQYQrOTb47Hrc7KMjLdxkppYCDKsTUy5WhuRs7w@mail.gmail.com>
	<4186d5662b3fb21af1b45f8a335414d3@mgebm.net>
	<20110930181914.GA17817@mgebm.net>
Date: Fri, 30 Sep 2011 14:16:25 -0700
Message-ID: <CANN689EN8KsBZj_9cABjJoZNou_UegZ8uqB4Lx=uM-B_4aCd7A@mail.gmail.com>
Subject: Re: [PATCH 0/9] V2: idle page tracking / working set estimation
From: Michel Lespinasse <walken@google.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Michael Wolf <mjwolf@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 11:19 AM, Eric B Munson <emunson@mgebm.net> wrote:
> I am able to recreate on a second desktop I have here (same model CPU but a
> different MB so I am fairly sure it isn't dying hardware).  It looks to me like
> a CPU softlocks and it stalls the process active there, so most recently that
> was XOrg.  The machine lets me login via ssh for a few minutes, but things like
> ps and cat or /proc files will start to work and give some output but hang.
> I cannot call reboot, nor can I sync the fs and reboot via SysRq.  My next step
> is to setup a netconsole to see if anything comes out in the syslog that I
> cannot see.

I haven't had time to try & reproduce locally yet (apologies - things
have been coming up at me).

But a prime suspect would be a bad interaction with
CONFIG_MEMORY_HOTPLUG, as Kamezama remarked in his reply to patch 4. I
think this could be the most likely cause of what you're observing.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
