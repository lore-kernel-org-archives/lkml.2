Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0GZQG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 12:06:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:38029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab0GZQG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 12:06:57 -0400
Message-ID: <4C4DB247.9060709@kernel.org>
Date: Mon, 26 Jul 2010 18:05:27 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, Sridhar Samudrala <sri@us.ibm.com>,
        netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH UPDATED 1/3] vhost: replace vhost_workqueue with per-vhost
 kthread
References: <4C03D983.9010905@kernel.org> <20100531160020.GC3067@redhat.com> <4C04D41B.4050704@kernel.org> <4C06A580.9060300@kernel.org> <20100722155840.GA1743@redhat.com> <4C48B664.9000109@kernel.org> <20100724191447.GA4972@redhat.com> <4C4BEAA2.6040301@kernel.org> <20100726152510.GA26223@redhat.com> <4C4DAB14.5050809@kernel.org> <20100726155014.GA26412@redhat.com>
In-Reply-To: <20100726155014.GA26412@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 26 Jul 2010 16:05:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/26/2010 05:50 PM, Michael S. Tsirkin wrote:
>> Hmmm... I'm not quite sure whether it's an optimization.  I thought
>> the patch was due to feeling uncomfortable about using barriers?
> 
> Oh yes. But getting rid of barriers is what motivated me originally.

Yeah, getting rid of barriers is always good.  :-)

> Is there a git tree with kthread_worker applied?
> I might do this just for fun ...

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-next

For the original implementaiton, please take a look at commit
b56c0d8937e665a27d90517ee7a746d0aa05af46.

* Can you please keep the outer goto repeat loop?  I just don't like
  outermost for (;;).

* Placing try_to_freeze() could be a bit annoying.  It shouldn't be
  executed when there's a work to flush.

* I think A - B <= 0 test would be more familiar.  At least
  time_before/after() are implemented that way.

Thanks.

-- 
tejun
