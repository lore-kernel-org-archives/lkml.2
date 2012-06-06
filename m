Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab2FFTlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 15:41:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab2FFTlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 15:41:09 -0400
Date: Wed, 6 Jun 2012 21:41:02 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 5/8] x86: apic: Try to spread IRQ vectors to different
 priority levels
Message-ID: <20120606194101.GB4777@dhcp-26-207.brq.redhat.com>
References: <20120605112408.GA11466@dhcp-26-207.brq.redhat.com>
 <87k3zk1cav.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3zk1cav.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 12:16:08PM -0700, Eric W. Biederman wrote:
> Alexander Gordeev <agordeev@redhat.com> writes:
> 
> > When assigning a new vector it is primarially done by adding 8 to the
> > previously given out vector number. Hence, two consequently allocated
> > vector numbers would likely fall into the same priority level. Try to
> > spread vector numbers to different priority levels better by changing
> > the step from 8 to 16.
> 
> A weird goal.  Given that linux ignores all priority levels internally
> we would be better incrementing by 1.  The practical problem is that
> some older hardware would fail if you had more than two devices per
> priority level.

Yes, the patch is aimed at those older hardware. For a newer hardware it will
not bring any change.

But also to stop asking myself: why 8, not 1 or 16? :)

> Eric

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
