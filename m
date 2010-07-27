Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0G0ISl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:18:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:40849 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab0G0ISi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:18:38 -0400
Message-ID: <4C4E963C.8080308@kernel.org>
Date: Tue, 27 Jul 2010 10:18:04 +0200
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
References: <4C48B664.9000109@kernel.org> <20100724191447.GA4972@redhat.com> <4C4BEAA2.6040301@kernel.org> <20100726152510.GA26223@redhat.com> <4C4DAB14.5050809@kernel.org> <20100726155014.GA26412@redhat.com> <4C4DB247.9060709@kernel.org> <4C4DB466.6000409@kernel.org> <20100726163108.GE26412@redhat.com> <4C4DD946.2080502@kernel.org> <20100726195714.GD27644@redhat.com>
In-Reply-To: <20100726195714.GD27644@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Jul 2010 08:18:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/26/2010 09:57 PM, Michael S. Tsirkin wrote:
>> For freeze, it probably is okay but for stop, I think it's better to
>> keep the semantics straight forward.
> 
> What are the semantics then? What do we want stop followed
> by queue and flush to do?

One scenario I can think of is the following.

 kthread_worker allows kthreads to be attached and stopped anytime, so
 if the caller stops the current worker while flushing is pending and
 attaches a new worker, the flushing which was pending will never
 happen.

But, in general, it's nasty to allow execution and its completion to
be separated.  Things like that are likely to bite us back in obscure
ways.  I think it would be silly to have such oddity in generic code
when it can be avoided without too much trouble.

Thanks.

-- 
tejun
