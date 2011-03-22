Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1CVAcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 20:32:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:58362 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab1CVAcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 20:32:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,222,1299484800"; 
   d="scan'208";a="406118112"
Subject: Re: [PATCH 04/10] block: initial patch for on-stack per-task
 plugging
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>
In-Reply-To: <4D87185C.4070001@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	 <1295659049-2688-5-git-send-email-jaxboe@fusionio.com>
	 <AANLkTimEyLdYhCc7Ft4i-=us5kTVDAB5GtNOnvabhmUH@mail.gmail.com>
	 <20110316173148.GC13562@redhat.com>
	 <1300323609.2337.117.camel@sli10-conroe>  <4D81D7D5.7000806@fusionio.com>
	 <1300430212.2337.141.camel@sli10-conroe> <4D83560E.8000002@fusionio.com>
	 <4D83639A.3060407@fusionio.com> <1300690368.2337.148.camel@sli10-conroe>
	 <4D87185C.4070001@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 08:32:15 +0800
Message-ID: <1300753935.2337.149.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-21 at 17:20 +0800, Jens Axboe wrote:
> On 2011-03-21 07:52, Shaohua Li wrote:
> >> Gave it a quick test spin, as suspected it had a few issues. This one
> >> seems to work. Can you toss it through that workload and see if it fares
> >> better?
> > yes, this fully restores the regression I saw. But I have accounting
> > issue:
> 
> Great!
> 
> > 1. The merged request is already accounted when it's added into plug
> > list
> 
> Good catch. I've updated the patch and merged it now, integrating this
> accounting fix.
> 
> > 2. drive_stat_acct() is called without any protection in
> > __make_request(). So there is race for in_flight accounting. The race
> > exists after stack plug is added, so not because of this issue.
> > Below is the extra patch I need to do the test.
> 
> Looks fine. Can I add your signed-off-by to this patch? I'll merge it as
> a separate fix.
Sure.
Signed-off-by: Shaohua Li<shaohua.li@intel.com>

