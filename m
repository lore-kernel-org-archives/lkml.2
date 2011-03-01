Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab1CAQEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:04:40 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:36224 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab1CAQEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:04:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=M8v+pp
	Yi9U77Nv+TQJVyt2i5SJcAyk7+DvMEVoYz1ReQfxnxYq68Ky0u/FyI3IuA1PlIDB
	M3oRkU3aMyHRpw0TEPtGsVOUhTDv3DImjnc1G9MX7ku2tGJs1lnux2wSYTJu100P
	KPX+aVpGxZfmOcdIhreq2nH4DPBCyhK156b74=
Subject: Re: [PATCH 02/10] Introduce mm_has_pending_aio() helper
From: Nathan Lynch <ntl@pobox.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Oren Laadan <orenl@cs.columbia.edu>, linux-aio@kvack.org
In-Reply-To: <x494o7mrgrh.fsf@segfault.boston.devel.redhat.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
 <1298936432-29607-3-git-send-email-ntl@pobox.com>
 <x494o7mrgrh.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 10:04:24 -0600
Message-ID: <1298995464.461.9.camel@tp-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: C6A3CE10-441D-11E0-BEF7-AF401E47CF6F-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 10:40 -0500, Jeff Moyer wrote:
> 
> ntl@pobox.com writes:
> 
> > From: Nathan Lynch <ntl@pobox.com>
> >
> > Support for AIO is on the to-do list, but until that is implemented,
> > checkpoint will have to fail if a mm_struct has outstanding AIO
> > contexts.  Add a mm_has_pending_aio() helper function for this
> > purpose.
> 
> Just because a process has an io context, doesn't mean that the process
> has active outstanding requests.  So, is this really what you wanted to
> test?

As a temporary measure, yeah.  We haven't settled on code to
record/restore the io context objects themselves, so we do want to bail
if we encounter any.  I realize now the name of the function doesn't
actually express this well.  Will try to come up with something better
for the next round.

Thanks!


