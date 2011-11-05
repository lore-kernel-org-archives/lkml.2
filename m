Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab1KESEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 14:04:09 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:41360 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1KESEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 14:04:07 -0400
Subject: Re: [GIT PULL] ib_srpt: Initial SRP Target merge for v3.2-rc1
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <CAO+b5-pOi_+Y+jcExxEzParHOdU6YB4WaB-onH_PLXugzLKjzg@mail.gmail.com>
References: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-pOi_+Y+jcExxEzParHOdU6YB4WaB-onH_PLXugzLKjzg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Nov 2011 11:04:03 -0700
Message-ID: <1320516243.5859.184.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-05 at 08:37 +0100, Bart Van Assche wrote:
> On Fri, Nov 4, 2011 at 9:10 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > This is the PULL request for an initial merge of the ib_srpt driver
> > using mainline target infrastructure into v3.2-rc1.
> 
> In case anyone is interested, the most important unaddressed comments
> for this version of ib_srpt are:
> - There are still too many module parameters. This makes ib_srpt
> harder to use than necessary because several of these parameters can
> only be set at module load time.

Can you be more specific here..?  I went through the module parameters
and made the ones that where used in a per-port specific context into
configfs attributes as Roland recommended, but it seems like you are
saying that more should be made into attributes.  Which ones..?

> - The last WQE event can arrive before the queue pair is reset,
> resulting in a hanging session and blocking future logins
> (http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg09678.html).

Yep, was going to get this resolved post merge along with my patch now
in lio-core.git to address active I/O shutdown with ib_srpt.

> - The "ib_srpt: Convert srp_max_rdma_size into per port configfs
> attribute" contradicts the I/O controller concept. This is a bug.
> (http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg09677.html).
> 

As mentioned in the thread, I deferred to Roland's input on that one.
So you're saying this should be made back into a module parameter now,
or what..?

--nab


