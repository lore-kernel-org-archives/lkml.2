Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab1HZAJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 20:09:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42833 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab1HZAJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 20:09:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 26 Aug 2011 09:02:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, jackdachef@gmail.com, cyclonusj@gmail.com
Subject: Re: Subject: [PATCH V7 1/4] mm: frontswap: swap data structure
 changes
Message-Id: <20110826090214.2f7f2cdc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <8a95a804-7ba3-416e-9ba5-8da7b9cabba5@default>
References: <20110823145755.GA23174@ca-server1.us.oracle.com
 20110825143312.a6fe93d5.kamezawa.hiroyu@jp.fujitsu.com>
	<8a95a804-7ba3-416e-9ba5-8da7b9cabba5@default>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 10:11:11 -0700 (PDT)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> > From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> > Subject: Re: Subject: [PATCH V7 1/4] mm: frontswap: swap data structure changes
> 
> Hi Kamezawa-san --
> 
> Domo arigato for the review and feedback!
> 
> > Hmm....could you modify mm/swapfile.c and remove 'static' in the same patch ?
> 
> I separated out this header patch because I thought it would
> make the key swap data structure changes more visible.  Are you
> saying that it is more confusing?

Yes. I know you add a new header file which is not included but..


At reviewing patch, I check whether all required changes are done.
In this case, you turned out the function to be externed but you
leave the function definition as 'static'. This unbalance confues me.

I always read patches from 1 to END. When I found an incomplete change
in patch 1, I remember it and need to find missng part from patch 2->End. 
This makes my review confused a little.

In another case, when a patch adds a new file, I check Makefile change.
Considering dependency, the patch order should be

	[patch 1] Documentaion/Config
	[patch 2] Makefile + add new file.

But plesse note: This is my thought. Other guys may have other idea.

Thanks,
-Kame

