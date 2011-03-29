Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1C2Nmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:42:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58040 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab1C2Nmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:42:50 -0400
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        dm-devel@redhat.com, neilb@suse.de
Subject: Re: Please revert a91a2785b20
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <alpine.LFD.2.00.1103290006070.2774@localhost6.localdomain6>
	<alpine.LFD.2.00.1103290040300.2774@localhost6.localdomain6>
	<20110328230319.GA12790@redhat.com> <4D918347.7050500@fusionio.com>
	<20110329132032.GA22921@redhat.com>
Date: Tue, 29 Mar 2011 09:42:08 -0400
In-Reply-To: <20110329132032.GA22921@redhat.com> (Mike Snitzer's message of
	"Tue, 29 Mar 2011 09:20:32 -0400")
Message-ID: <yq1lizyhwlr.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110013 (No Gnus v0.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D91E1B6.007B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike,

Mike> But I think we have a related issue that needs discussion, given
Mike> that an integrity profile mismatch will cause MD's assemble to
Mike> fail (rather than warn and continue to assemble without integrity
Mike> support).

Mike> DM doesn't fail to load a DM device due to a integrity profile
Mike> mismatch; it just emits a warning and continues.

Mike> In contrast, MD will now disallow adding a normal disk (without
Mike> integrity support) to an array that has historically had a
Mike> symmetric integrity profile across all members.

You would invalidate all your existing integrity metadata, tagging,
etc. on existing metadevice members. That seems to be a policy decision,
so if we go down that path it would have to be keyed off a force
assembly option passed down from userland tooling. Turning off features
and/or losing metadata really should not be done without the user's
explicit consent.

Also, let's assume you run an integrity-aware app on a DM device and you
add a non-integrity drive. The DM device is then no longer capable of
carrying integrity metadata out to storage. What happens to the app?
What about outstanding writes with metadata attached?

Good discussion topic for next week, methinks...

-- 
Martin K. Petersen	Oracle Linux Engineering
