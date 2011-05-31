Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab1EaOw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:52:59 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:33877 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754528Ab1EaOw6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:52:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Zq/hSMMZF6yfLQxxR0ijbOxhBfIMXvjtPUPWG9k7zfkdcNU341guqpcgjHjRscUyum
         SGseAQ3KEDNbVZWnqMqrebUZyuxZ6UDZm/Uzp2b4uTWz1PdJap6ewArUcVfIHasKJCq7
         s3cynShoDwv4glE24ruGLF7owt8q/pb+Pa404=
MIME-Version: 1.0
In-Reply-To: <BANLkTinu7dX5Tfhs0ak0BEfc212mpJKb+w@mail.gmail.com>
References: <cover.1306780983.git.bengardiner@nanometrics.ca>
	<BANLkTinu7dX5Tfhs0ak0BEfc212mpJKb+w@mail.gmail.com>
Date: Tue, 31 May 2011 10:52:56 -0400
Message-ID: <BANLkTikPqkDON4mzBEko46JdgACrbTOiiA@mail.gmail.com>
Subject: Re: [PATCH 0/3] fix-up free space earlier in mount_ubifs()
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: "Matthew L. Creech" <mlcreech@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Tue, May 31, 2011 at 10:43 AM, Matthew L. Creech <mlcreech@gmail.com> wrote:
> On Mon, May 30, 2011 at 2:56 PM, Ben Gardiner
> <bengardiner@nanometrics.ca> wrote:
>> In testing Mattew Creech's free-space-fixup flag series I found that was unable
>> to boot a da850evm which had flashed to it's NAND a ubinized image containing a
>> UBIFS that has the free-space-fixup flag set.
>>
>> The cause of the problem was found to be the call to ubifs_write_master() from
>> mount_ubifs() as is evidenced the backtrace produced by the assertion
>> introduced in the first patch of this series; where the assertion introduced is
>> that c->space_fixup is false when ubifs_write_node() is called.
>>
>
> Interesting - so the problem is that if ubifs_read_master() resizes
> the master node, a subsequent attempt to read the first (c->mst_offs +
> c->mst_node_alsz) bytes from the master LEB fails?
>
> I wonder why this is the case when free-space fixup is enabled, and
> not otherwise?  The -EBADMSG seems to imply that this is the original
> problem that the fix-up is intended to solve - i.e. the master node
> has empty pages with non-empty OOB values, and writing to them results
> in a bogus ECC.

Right. I should have mentioned that it is also true that without
free-space-fixup the initial flash of a UBInized image containing a
UBIFS volume results in a bootable system which can mount the rootfs
_the first time only_ subsequent attemps at mounting result in a
failure to mount due to -74 errors.

> Just trying to fully understand the error.  :)  That aside, this patch
> set makes sense to me.  Thanks!

Thank you for your endorsement. Can we take that as a Reviewed-by ?

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
