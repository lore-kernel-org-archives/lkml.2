Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1BPRWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:22:53 -0500
Received: from smtp-out.google.com ([74.125.121.67]:54383 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab1BPRWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:22:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=DP5Xvq0ZIgr7tKrZAiMhgK/D/03mUP7Pr7K1ym30oJzZYNvnGAn6I26wWeW0PuCUYL
         3FFD0Apkp7BU9myxKZSA==
MIME-Version: 1.0
In-Reply-To: <4D5B2C07.9050909@cn.fujitsu.com>
References: <4D51ED26.8050809@cn.fujitsu.com> <4D539821.1090703@cn.fujitsu.com>
 <20110210205722.GB2600@redhat.com> <4D55EEBB.8060304@cn.fujitsu.com>
 <20110214180428.GF13097@redhat.com> <4D59E728.3030209@cn.fujitsu.com>
 <20110215142752.GC27296@redhat.com> <4D5B2C07.9050909@cn.fujitsu.com>
From: Divyesh Shah <dpshah@google.com>
Date: Wed, 16 Feb 2011 09:22:28 -0800
Message-ID: <AANLkTi=Lrb+CLo_dn9L+RhWUf7SAaTepFrdpje+PgqMX@mail.gmail.com>
Subject: Re: [PATCH 5/6 v4] cfq-iosched: CFQ group hierarchical scheduling and
 use_hierarchy interface
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 5:44 PM, Gui Jianfeng
<guijianfeng@cn.fujitsu.com> wrote:
> Hmm, it seems memcg aggregating stats in parent group.
> But do we really need to do that in kernel? I think it's easier to do it in
> userland, and it makes kernel much simpler.
>

I would prefer having stats aggregated up the hierarchy. One trick we
used at Google earlier was to do lazy updates for most stats. So we
would accumulate stats for a given timeslice and at the end of that
timeslice propagate those counts all the way up to the parent. For
device info like this, the update can be instantaneous since its not a
very frequent event. It would also be very useful to distinguish
between stats for the cgroup itself vs total values accumulated from
the subtree rooted at that cgroup like memcg does.

-- 
Thanks,
Divyesh
