Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0JJQSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 12:18:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab0JJQSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 12:18:22 -0400
Date: Sun, 10 Oct 2010 18:17:59 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 02/12] Halt vcpu if page it tries to access is
 swapped out.
Message-ID: <20101010161759.GT2397@redhat.com>
References: <1286207794-16120-1-git-send-email-gleb@redhat.com>
 <1286207794-16120-3-git-send-email-gleb@redhat.com>
 <4CAD97D0.70100@redhat.com>
 <20101007174716.GD2397@redhat.com>
 <4CB0B4BA.5010901@redhat.com>
 <20101010072946.GJ2397@redhat.com>
 <4CB1E1ED.6050405@redhat.com>
 <4CB1E22F.9060008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB1E22F.9060008@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 05:56:31PM +0200, Avi Kivity wrote:
>  On 10/10/2010 05:55 PM, Avi Kivity wrote:
> >>There is special completion that tells guest to wake all sleeping tasks
> >>on vcpu. It is delivered after migration on the destination.
> >>
> >>
> >
> >Yes, I saw.
> >
> >What if you can't deliver it?  is it possible that some other vcpu
> >will start receiving apfs that alias the old ones?  Or is the
> >broadcast global?
> >
> 
> And, is the broadcast used only for migrations?
> 
Any time apf is enabled on vcpu broadcast is sent to the vcpu. Guest should be
careful here and do not write to apf msr without a reason.

--
			Gleb.
