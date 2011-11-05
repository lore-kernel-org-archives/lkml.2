Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab1KEHh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 03:37:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58745 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1KEHh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 03:37:26 -0400
MIME-Version: 1.0
In-Reply-To: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
References: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
Date: Sat, 5 Nov 2011 08:37:24 +0100
X-Google-Sender-Auth: FB6TVzrJVYj7PWPSPUnjWjLERbQ
Message-ID: <CAO+b5-pOi_+Y+jcExxEzParHOdU6YB4WaB-onH_PLXugzLKjzg@mail.gmail.com>
Subject: Re: [GIT PULL] ib_srpt: Initial SRP Target merge for v3.2-rc1
From: Bart Van Assche <bvanassche@acm.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 4, 2011 at 9:10 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> This is the PULL request for an initial merge of the ib_srpt driver
> using mainline target infrastructure into v3.2-rc1.

In case anyone is interested, the most important unaddressed comments
for this version of ib_srpt are:
- There are still too many module parameters. This makes ib_srpt
harder to use than necessary because several of these parameters can
only be set at module load time.
- The last WQE event can arrive before the queue pair is reset,
resulting in a hanging session and blocking future logins
(http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg09678.html).
- The "ib_srpt: Convert srp_max_rdma_size into per port configfs
attribute" contradicts the I/O controller concept. This is a bug.
(http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg09677.html).

Bart.
