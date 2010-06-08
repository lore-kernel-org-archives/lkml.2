Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab0FHQCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 12:02:25 -0400
Received: from smtp-out.google.com ([74.125.121.35]:61159 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252Ab0FHQCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 12:02:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:content-transfer-encoding;
	b=fee1xTQ+Rz3Qkz1NAdzZD1ftIwzjpuu5NGkVuHXJC578S3uEVOQQl7xnl50gVt1j0
	RXVEtzDjTd4pVbtbncjAQ==
MIME-Version: 1.0
In-Reply-To: <20100525183051.GA692@redhat.com>
References: <1274802411-26613-1-git-send-email-wad@chromium.org>
	<1274802411-26613-2-git-send-email-wad@chromium.org>
	<20100525155535.GA811@infradead.org>
	<20100525160550.GC28588@agk-dp.fab.redhat.com>
	<AANLkTin6Nt2TqxlF9kQJZThI7pZ6wqAwSlg9GnqkKB-v@mail.gmail.com>
	<20100525172110.GA6046@infradead.org>
	<20100525183051.GA692@redhat.com>
Date: Tue, 8 Jun 2010 11:02:18 -0500
X-Google-Sender-Auth: xMqcVAoGvegjabak2wvIQNsh5EQ
Message-ID: <AANLkTimjQV4kBoYiTC4CRiCtcLzDltaVI8p4i8bQsEAK@mail.gmail.com>
Subject: Re: [PATCH 2/2] init, mount: export the name_to_dev_t symbol
From: Will Drewry <wad@chromium.org>
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@suse.de>,
       Tejun Heo <tj@kernel.org>, Scott James Remnant <scott@ubuntu.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Harald Hoyer <harald@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 1:30 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Tue, May 25 2010 at  1:21pm -0400,
> Christoph Hellwig <hch@infradead.org> wrote:
>
>> On Tue, May 25, 2010 at 11:11:33AM -0500, Will Drewry wrote:
>> > In addition to getting rid of the code duplication, I'd like device-mapper
>> > to be able to resolve slave devices at boot-time to accommodate a
>> > do_mounts_dm.c equivalent to do_mounts_md.c:
>>
>> So please add a do_mounts_dm.c instead of pushing this somewhere it
>> doesn't belong to.
>
> He is proposing doing just that, you cut out the patchwork url he
> already shared: https://patchwork.kernel.org/patch/101024/
>
> Will's intentions are good: avoid code duplication.
>
> He is also trying to keep DM-specific common code in drivers/md/
>
> So in this instance, avoiding the need to export name_to_dev_t would
> require splitting the internal DM __table_get_device (or more likely:
> dm_get_device) out to a public facing interface that takes a dev_t.

FWIW, I mailed out a new patchset which does not expect the dm core
code to understand device paths before there is a root device.  Now it
walks the target parameters supplied to do_mounts_dm.c and attempts
a best-guess replacement with major:minor numbers.  It's not as succinct,
but it achieves the isolation requested and negates the need for the
patch on this thread.

The relevant init-time patchwork link:
  https://patchwork.kernel.org/patch/104861/
(Full patchset is 58-61)

Any and all comments will be appreciated - thanks!
will
