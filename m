Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab1KFUEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 15:04:40 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:33520 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1KFUEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 15:04:39 -0500
Subject: Re: [GIT PULL] ib_srpt: Initial SRP Target merge for v3.2-rc1
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <CAO+b5-p0gLueksp7a8RVm9A1Qe_9xc-fNSNX0NY0W7CNtGnSYw@mail.gmail.com>
References: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-pOi_+Y+jcExxEzParHOdU6YB4WaB-onH_PLXugzLKjzg@mail.gmail.com>
	 <1320516243.5859.184.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-rjKdZtBjZ=qyRnavDubtHWSGihROHEUok6o+bCNc3TpA@mail.gmail.com>
	 <1320574170.5859.370.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-p0gLueksp7a8RVm9A1Qe_9xc-fNSNX0NY0W7CNtGnSYw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Nov 2011 12:04:30 -0800
Message-ID: <1320609870.10690.5.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-06 at 14:20 +0100, Bart Van Assche wrote:
> On Sun, Nov 6, 2011 at 11:09 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > We have also discussed srpt_service_guid a bit before, which you
> > indicated needed to stay in current code as global scope, and presumably
> > should not change value after loading.  Looking at the actual usage, one
> > post merge improvement we can consider is seeing if it's possible to
> > move ib_cm_listen() out of srpt_add_one() and have it driven instead by
> > configfs context in order to optionally set srpt_service_guid on a per
> > target endpoint basis to get us some more flexibility.
> 
> ib_sprt defines a single I/O controller profile and hence there should
> be exactly one GUID associated with it.

Ok, so if it exists, it needs to stay global scope.

> 
> > For the "last WQE" you've mentioned, I'm happy to accept a patch to
> > address this as you know the code better than me.  Otherwise, I'll be
> > digging this out of your out-of-tree code as a seperate item and
> > figuring out how to reproduce and test this special case.
> 
> I'll post a patch to address last WQE handling.
> 

Thank you for handling this one.  I've merged your patch into lio-core
and will get this included into target-pending with next set of
post-merge rc-fixes.

Thanks Bart!

--nab


