Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab1CAAUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 19:20:18 -0500
Received: from smtp-out.google.com ([74.125.121.67]:57374 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab1CAAUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 19:20:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=rv/+b8rAS/gVx49N5SI74QZ3FjwVziWIY0hCb68UrsI+3SjFo/OBadMLuvhPwQN9Hq
         IhFhPj3+CqBWl5KS9vLw==
MIME-Version: 1.0
From: Justin TerAvest <teravest@google.com>
Date: Mon, 28 Feb 2011 16:19:43 -0800
Message-ID: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com>
Subject: RFC: default group_isolation to 1, remove option
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>, lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

I'd like to propose removing the group_isolation setting and changing
the default to 1. Do we know if anyone is using group_isolation=0 to get
easy group separation between sequential readers and random readers?

Allowing group_isolation complicates implementing per-cgroup request
descriptor pools when a queue is moved to the root group. Specifically,
if we have pools per-cgroup, we would be forced to use request
descriptors from the pool for the "original" cgroup, while the requests
are actually being serviced by the root cgroup.

That might be acceptable, but I figured this would be a good opportunity
to revisit keeping queues within their original groups.

I know this discussion has come up before. I'm curious if we have a good
reason to keep it around right now. I'd be happy to do some investigation
to help make my case.

Thanks,
Justin
