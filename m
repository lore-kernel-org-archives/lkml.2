Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1KFNUv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 08:20:51 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51482 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1KFNUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 08:20:49 -0500
MIME-Version: 1.0
In-Reply-To: <1320574170.5859.370.camel@haakon2.linux-iscsi.org>
References: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
	<CAO+b5-pOi_+Y+jcExxEzParHOdU6YB4WaB-onH_PLXugzLKjzg@mail.gmail.com>
	<1320516243.5859.184.camel@haakon2.linux-iscsi.org>
	<CAO+b5-rjKdZtBjZ=qyRnavDubtHWSGihROHEUok6o+bCNc3TpA@mail.gmail.com>
	<1320574170.5859.370.camel@haakon2.linux-iscsi.org>
Date: Sun, 6 Nov 2011 14:20:47 +0100
X-Google-Sender-Auth: KZXm7k8HfO8ePGoKSBl2CsEABVU
Message-ID: <CAO+b5-p0gLueksp7a8RVm9A1Qe_9xc-fNSNX0NY0W7CNtGnSYw@mail.gmail.com>
Subject: Re: [GIT PULL] ib_srpt: Initial SRP Target merge for v3.2-rc1
From: Bart Van Assche <bvanassche@acm.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 11:09 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> We have also discussed srpt_service_guid a bit before, which you
> indicated needed to stay in current code as global scope, and presumably
> should not change value after loading.  Looking at the actual usage, one
> post merge improvement we can consider is seeing if it's possible to
> move ib_cm_listen() out of srpt_add_one() and have it driven instead by
> configfs context in order to optionally set srpt_service_guid on a per
> target endpoint basis to get us some more flexibility.

ib_sprt defines a single I/O controller profile and hence there should
be exactly one GUID associated with it.

> For the "last WQE" you've mentioned, I'm happy to accept a patch to
> address this as you know the code better than me.  Otherwise, I'll be
> digging this out of your out-of-tree code as a seperate item and
> figuring out how to reproduce and test this special case.

I'll post a patch to address last WQE handling.

Bart.
