Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab1DFUHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:07:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58742
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756688Ab1DFUHH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:07:07 -0400
Date: Wed, 06 Apr 2011 13:06:30 -0700 (PDT)
Message-Id: <20110406.130630.229741188.davem@davemloft.net>
To: lucian.grijincu@gmail.com
Cc: adobriyan@gmail.com, ebiederm@xmission.com, tavi@cs.pub.ro,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 01/24] sysctl: net: call unregister_net_sysctl_table
 where needed
From: David Miller <davem@davemloft.net>
In-Reply-To: <BANLkTik6PKYFyjnGLWoeRBrwF4sPZaaGWw@mail.gmail.com>
References: <05ae3c2fdd2db1f6a2fd3cd900164667e615f4f8.1301711868.git.lucian.grijincu@gmail.com>
	<20110406.125256.102558618.davem@davemloft.net>
	<BANLkTik6PKYFyjnGLWoeRBrwF4sPZaaGWw@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Wed, 6 Apr 2011 22:04:53 +0200

> On Wed, Apr 6, 2011 at 9:52 PM, David Miller <davem@davemloft.net> wrote:
>> Oops, hmmm...  Can this actually cause any real problems currently?
>>
>> If so I'd like to toss this specific patch into net-2.6
> 
> 
> Nope:
> 
> void unregister_net_sysctl_table(struct ctl_table_header *header)
> {
>         unregister_sysctl_table(header);
> }
> EXPORT_SYMBOL_GPL(unregister_net_sysctl_table);

Ok, that's good.

> But I thought that in the future, if something special needs to be
> done for unregister_net_sysctl_table, it would be better to have these
> consistent. I'll do a check on all the tree to see if there are other
> cases.
> 
> Another approach would be to remove unregister_net_sysctl_table, as it
> does nothing different of unregister_sysctl_table and let our future
> selves deal with the problem.
> 
> Can you tell me what you'd like?

I think the thing to do is to keep this patch as it is, and only apply
it along with this cookie patch series, for -next.
