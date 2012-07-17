Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab2GQVMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:12:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65234 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2GQVMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:12:17 -0400
Message-ID: <5005D52B.30809@redhat.com>
Date: Tue, 17 Jul 2012 23:12:11 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mike Christie <michaelc@cs.wisc.edu>
CC: Christoph Hellwig <hch@infradead.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention conditions
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com> <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com> <50044D56.6000400@redhat.com> <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com> <50052390.7030908@redhat.com> <1342514444.3039.23.camel@dabdike.int.hansenpartnership.com> <5005285E.8060706@redhat.com> <1342516317.3039.35.camel@dabdike.int.hansenpartnership.com> <20120717163612.GA15995@infradead.org> <50059713.7090606@redhat.com> <5005B2AC.6020102@cs.wisc.edu> <5005B39D.6030905@cs.wisc.edu>
In-Reply-To: <5005B39D.6030905@cs.wisc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2012 20:49, Mike Christie ha scritto:
> > Not sure if we are talking about the same thing.
> > 
> > So can virtio-scsi send a UA with asc/ascq that indicates the lun
> > changed size? Other drivers do this. I updated Hannes's patches the
> > other day to support UAs like those in userspace.
> > 
> > I just saw the code in the patch where virtio-scsi gets that event.
> Was not done. I meant I saw that patch where virtio-scsi gets that
> virtio_scsi_event and kicks of a rescan based off of that.

Yes, it sends both (event + UA).  Right now Linux ignores the UA, and I
wanted virtio-scsi to match real hardware as much as possible so I
copied what aacraid does.  The event also has the advantage over UA that
it the revalidate is done immediately, not the next time the unit is
accessed.

Paolo
