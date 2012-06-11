Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2FKKB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:01:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab2FKKB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:01:57 -0400
Message-ID: <4FD5C205.5070901@redhat.com>
Date: Mon, 11 Jun 2012 13:01:41 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yongjie.ren@intel.com" <yongjie.ren@intel.com>
Subject: Re: [PATCH] KVM: Use IRQF_ONESHOT for assigned device MSI interrupts
References: <20120601161521.26935.25606.stgit@bling.home> <4FC8F042.5050600@siemens.com> <1338570192.23475.25.camel@bling.home> <4FC8F867.7080103@siemens.com> <1338573558.23475.41.camel@bling.home> <4FC90961.8030701@siemens.com> <4FCB2359.9020505@redhat.com> <alpine.LFD.2.02.1206041235540.3086@ionos> <4FCC9EAC.9090007@siemens.com> <20120608143927.GA4949@redhat.com> <4FD21151.9090608@siemens.com>
In-Reply-To: <4FD21151.9090608@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 05:50 PM, Jan Kiszka wrote:
> 
>> 
>> Pls correct me if I'm wrong.
> 
> Well, IIRC, the "don't loop over all vcpus with IRQs or preemption
> disabled" was one argument against direct legacy interrupt injection as
> well. That's what I kept in mind from those discussions. Maybe Avi can
> comment on the current position.

It's still my position.

IMO we need something like struct gfn_to_hva_cache for interrupts.  If
it's in the cache, we fast-path it from the interrupt handler.  If not,
fall back to a workqueue and let it refill the cache.

-- 
error compiling committee.c: too many arguments to function
