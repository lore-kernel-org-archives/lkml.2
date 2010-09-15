Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0IOOUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:20:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab0IOOUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:20:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=BeiEa9jvDEgb55Lrev6UtXYtImJAp3cc23Ry2Z7A6whpkZrx9UpkYRPtA8yYsVjB+U
         8LmsAalBineZcYAT92sIFbjKiDnYAg01lyp8BptqOvXHwAhGPFh46bOxj2E39LfYUCNy
         cEWTHknURBP+O/ktevI7CaFR835gkUwVuRhgc=
MIME-Version: 1.0
From: Mike Snitzer <snitzer@redhat.com>
Date: Wed, 15 Sep 2010 10:20:29 -0400
X-Google-Sender-Auth: 2XZnk7R1W3xqtagkEfmpwmZAKfM
Message-ID: <AANLkTinpFpAdiU=kNTmL4FNn4kTyRUiVcKxnq=mi2O2D@mail.gmail.com>
Subject: new "multi-version snapshot target" [was: Re: [PATCH] vfs: calculate
 block-size correctly]
To: McPacino <mcpacino@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 4:14 AM, McPacino <mcpacino@gmail.com> wrote:
> On Tue, Sep 14, 2010 at 7:09 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>>
>> On Wed, 8 Sep 2010 18:07:10 +0800
>> Cong Meng <mcpacino@gmail.com> wrote:
>>
>> > I sent this patch half mount ago, but no response at all. If anything is
>> > wrong, please tell me. Thanks a lots. This is my first time to send patch
>> > to linux kernel.
>> >
>> > The invocation of __getblk(bdev, block, size) will cause kernel stall if
>> > the @size parameter is not equal to the blockr-size of @bdev, which is saved
>> > in bdev->bd_inode->i_blkbits.
>> >
>> > submit_bh() has the similar problem.
>> >
>> > This patch calculates the block-size using i_blkbits.
>> > So that, for example, __getblk() can get a 4K buffer head while the
>> > block-size of @bdev is 1K.
>> >
>>
>> This comes up every couple of years and iirc we always decided that
>> it's a bug in the calling code somewhere.  How did you hit it?
>>
>
> I am working on a new multi-version snapshot target module for device-mapper
> which is almost done.

And you hope to have this code included upstream?  Do you intend to
post your patches to dm-devel?

Thanks,
Mike
