Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab2BASq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:46:59 -0500
Received: from mga05.intel.com ([192.55.52.89]:16243 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755326Ab2BASqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:46:55 -0500
MIME-Version: 1.0
In-Reply-To: <CACLa4ptFgmCL7Z4e-YO9XJ_zkr=kOHSJ7cA8u3DPvVc-2LBfRw@mail.gmail.com>
References: <1327961644-6886-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1327961644-6886-6-git-send-email-zohar@linux.vnet.ibm.com>
	<CACLa4ptFgmCL7Z4e-YO9XJ_zkr=kOHSJ7cA8u3DPvVc-2LBfRw@mail.gmail.com>
Date: Wed, 1 Feb 2012 20:46:54 +0200
Message-ID: <CALLzPKZcr8fZ9-VXqLHN=H69+GOnp48CjZX+xxmBBksbmJsLxw@mail.gmail.com>
Subject: Re: [RFC][PATCH v1 5/9] ima: allocating iint improvements
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 6:58 PM, Eric Paris <eparis@parisplace.org> wrote:
> On Mon, Jan 30, 2012 at 5:14 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
>>
>
>>  static struct rb_root integrity_iint_tree = RB_ROOT;
>> -static DEFINE_SPINLOCK(integrity_iint_lock);
>> +static DEFINE_RWLOCK(integrity_iint_lock);
>>  static struct kmem_cache *iint_cache __read_mostly;
>
> Has any profiling been done here?   rwlocks have been shown to
> actually be slower on multi processor systems in a number of cases due
> to the cache line bouncing required.  I believe the current kernel
> logic is that if you have a short critical section and you can't show
> profile data the rwlocks are better, just stick with a spinlock.

No, I have not done any profiling.
My assumption was that rwlocks are better when there many readers.
If what you say is true then rwlocks are useless...
With big sections it is necessary to use rw semaphores.

- Dmitry
