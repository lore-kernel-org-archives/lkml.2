Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab2IKWK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:10:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54698 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2IKWKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:10:24 -0400
Message-ID: <504FB6CB.6020607@redhat.com>
Date: Wed, 12 Sep 2012 00:10:19 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com> <20120911165953.GK7677@google.com> <504F7B65.9090603@redhat.com> <20120911182904.GS7677@google.com> <504F88CB.6030105@redhat.com> <20120911191325.GU7677@google.com> <504F8FF0.3000408@redhat.com> <20120911200150.GV7677@google.com> <504FB22E.4090707@redhat.com> <20120911220218.GH7677@google.com>
In-Reply-To: <20120911220218.GH7677@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/09/2012 00:02, Tejun Heo ha scritto:
> SG_IO itself is a bypassing interface.  It bypasses most of block
> layer and the kernel doesn't have any idea (apart from the adhoc
> filtering) about what's going on.

That's very much the point.  The guest must have free reins.

You asked "Could being able to bypass the filters for this "you own this
LUN" be a solution?", I said yes and outlined how.  Do you agree with
the proposed solution?

> The problem can be approached from
> both directions (make use of OS IO layer improving it as needed or add
> more intelligence to the bypass thing)

Or remove intelligence if it gets in the way.  Of course the removal
must be done by an appropriately-privileged program.

> and I'm not sure at all adding
> more capability to the adhoc filtering is the better direction.

Sure, I'm fine with leaving the current ad hoc filtering aside.  Again,
I was hoping to get most of the job done by loosening the filter a bit,
but discussion is inversely proportional to patch length sometimes.

Paolo
