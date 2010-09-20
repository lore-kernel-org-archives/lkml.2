Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab0ITTMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:12:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34481 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102Ab0ITTMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:12:19 -0400
Date: Mon, 20 Sep 2010 21:12:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Will Drewry <wad@chromium.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        containers@lists.linux-foundation.org, Eugene Teo <eteo@redhat.com>,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] v2 exec: move core_pattern pipe helper into the crashing namespace
Message-ID: <20100920191214.GB7496@one.firstfloor.org>
References: <20100918012939.GA25046@redhat.com> <1284779629-15273-1-git-send-email-wad@chromium.org> <m1eico1cyv.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1eico1cyv.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The pipe process needs to run in the namespaces of the process who set
> the core pattern, not in the namespaces of the dumping process.
> Otherwise it is possible to trigger a privileged process to run in a
> context where it's reality that it expected, causing it to misuse
> it's privileges.  Even if we don't have a privilege problem I think
> we will have a case of mismatched functionality where the core pattern
> will not work as expected.

For me it seems rather the other way around: running the helper in some
highly priviledged namespace is more dangerous. If it runs in the 
same context as the crasher it can do the least amount of damage
relative to the crash process.

And as Will pointed out it's the only sane way to deal with net namespaces.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
