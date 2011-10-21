Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1JUR5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 13:57:33 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56408 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab1JUR5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 13:57:32 -0400
Subject: Re: [PATCH v3] virtio: Add platform bus driver for memory mapped
 virtio device
From: Pawel Moll <pawel.moll@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
In-Reply-To: <87ty75adtb.fsf@rustcorp.com.au>
References: <1317841030-17758-1-git-send-email-pawel.moll@arm.com>
	 <1317919843-8343-1-git-send-email-pawel.moll@arm.com>
	 <1317921230.28696.102.camel@hornet.cambridge.arm.com>
	 <87lisjq6tu.fsf@rustcorp.com.au>
	 <1318931075.3146.285.camel@hornet.cambridge.arm.com>
	 <87ty75adtb.fsf@rustcorp.com.au>
Date: Fri, 21 Oct 2011 18:57:24 +0100
Message-ID: <1319219844.5094.16.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 21 Oct 2011 17:57:24.0651 (UTC) FILETIME=[E3746FB0:01CC901A]
X-MC-Unique: 111102118572800201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-19 at 03:57 +0100, Rusty Russell wrote:
> > Oh, really? My host-side implementation is just doing that:
> > 
> >         addr += align - 1;
> >         addr &= ~(align - 1);
> 
> OK, so you're assuming power of 2.  Make sure you kill the guest or at
> least the device if it's not though.

Yep, I have assertions all around such places :-) (it's a non-production
code yet so I can do that)

> > \item The dynamic configuration changes, as described in p. 2.4.3
> > ``Dealing With Configuration Changes'' are not permitted.
> 
> This means some devices simply won't work, at least in theory.  Why
> don't you support this?

Uh. I simply forgot about it - my Host block device doesn't do that, so
I ignored that feature initially and then it slipped through cracks. And
till now I didn't realize that most of the drivers actually use this :-O
My fault.

Simple to fix anyway - I'll just add InterruptStatus register and use
second bit (same with InterruptACK) to get this through. Will be done on
Monday.

Any other final complaints regarding the interface while I'm on it? ;-)

Cheers!

Paweł


