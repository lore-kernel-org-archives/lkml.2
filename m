Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759663Ab2EVCX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:23:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758528Ab2EVCXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:23:25 -0400
Message-ID: <4FBAF88F.1040103@redhat.com>
Date: Tue, 22 May 2012 10:23:11 +0800
From: Amos Kong <akong@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@canonical.com>,
        containers@lists.linux-foundation.org, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, tj@kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] cgroup: fix device deny of DEV_ALL
References: <CAFeW=pZ8Y7ycxjxro7zBMqdtaCOYs4RmoxtDrsN8+mqLhOL--g@mail.gmail.com> <20120518081912.16779.21065.stgit@t> <20120521140324.GA5091@sergelap> <4FBADF1A.6040303@huawei.com> <20120522015426.GA10344@mail.hallyn.com> <20120522020857.GA10499@mail.hallyn.com>
In-Reply-To: <20120522020857.GA10499@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/05/12 10:08, Serge E. Hallyn wrote:
> At line 135, there is
>
> if (walk->type == DEV_ALL)
> 	goto remove;
>
> I wonder if that was meant to be 'if (wh->type == DEV_ALL)'.  That
> seems to fit better with what I would have meant to have happen.
> But it's already handled by line 342.  So I think deleting lines
> 135-136 might be best.  What do you think?

Hi Serge,

If we expect nothing changed ('a *:* rwm' doesn't change),
delete 135-136 will be ok.

But I have explained my patch in another email, I also think
it's unnecessary to remove 'a *:* rwm' before executing:
  @ echo 'b 253:3 rw'>  devices.deny

-- 
			Amos.
