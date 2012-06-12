Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab2FLSj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:39:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40477 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2FLSjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:39:25 -0400
Message-ID: <4FD78CD9.6080807@redhat.com>
Date: Tue, 12 Jun 2012 20:39:21 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: allow persistent reservations without CAP_SYS_RAWIO
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>   <1339518069.3050.8.camel@dabdike.int.hansenpartnership.com>   <4FD76D57.5020709@redhat.com> <4FD77438.6090202@redhat.com>  <1339521657.3050.13.camel@dabdike.int.hansenpartnership.com>  <4FD77B94.1030207@redhat.com> <1339524176.3050.18.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1339524176.3050.18.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/06/2012 20:02, James Bottomley ha scritto:
>> > Thanks for taking the time to explain---I knew about this, but I thought
>> > it could (perhaps should) be disabled on the SAN.  Anybody could already
>> > use reservation by transport ID if they had root access on the local
>> > machine, no?
> No ... it's required for multipath to work correctly and multipath is a
> usual enterprise feature.
> 
> The only way around this is either to trust your users or not to give
> out root ... and most data centres choose the latter.  It causes real
> pain from NPIV and SR-IOV ...

I can imagine...  my impression was that it would only affect whatever
LUNs the zoning allowed access to (NPIV is pretty much required to use
persistent reservations on guests, or guests will all share the same WWN).

Would it be acceptable to restrict access to PR OUT with ALL_TG_PT set,
and allow it freely without the flag?

Paolo
