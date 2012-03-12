Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab2CLSHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:07:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46471 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab2CLSHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:07:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120312180423.GC23255@google.com>
References: <1331582478-2259-1-git-send-email-levinsasha928@gmail.com> <20120312180423.GC23255@google.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 12 Mar 2012 20:06:53 +0200
Message-ID: <CA+1xoqdz+m7kK+XgsmwM2Bt07eLH294L_PT6DrUkhJvRzpUZCg@mail.gmail.com>
Subject: Re: [PATCH] blk-cgroup: Call cgroup_path only under cgroup lock
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 8:04 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Sasha.
>
> On Mon, Mar 12, 2012 at 04:01:18PM -0400, Sasha Levin wrote:
>> Since we can't keep rcu read lock during blkg_alloc(), we currently
>> call cgroup_path() without any locks at all.
>>
>> This patch adds cgroup locking before calling cgroup_path.
>>
>> This also fixes a lockdep warning on boot.
>>
>> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
>
> Which branch is this against?  There's already pending stat update
> patch from Vivek which fix this problem along with the percpu
> allocation problem.
>
> Thanks.

I've fixed it for linux-next.
