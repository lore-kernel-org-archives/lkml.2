Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613Ab2EJVmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:42:20 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49679 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761471Ab2EJVmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:42:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120510213556.GO23768@redhat.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<cb817596299fecd01ea36e4a80203f23165bda75.1336619038.git.koverstreet@google.com>
	<20120510213556.GO23768@redhat.com>
Date: Thu, 10 May 2012 14:42:17 -0700
Message-ID: <CAH+dOxJ2Vi=8Oq1zDZLmqD9-a_wgM=co3+xemw4XBoiDkh_4zg@mail.gmail.com>
Subject: Re: [dm-devel] [Bcache v13 01/16] Only clone bio vecs that are in use
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, I never got around to figuring out what needed to be done with the
bio integrity - presumably it'll have to be handled differently
somehow (I'm assuming an index in the integrity bvec is intended to
match up with an index in the regular bvec), but I don't have any way
to test the integrity stuff.

2012/5/10 Vivek Goyal <vgoyal@redhat.com>:
> On Wed, May 09, 2012 at 11:08:13PM -0400, Kent Overstreet wrote:
>
> [..]
>> -
>> -     if (bio_integrity(bio)) {
>> -             bio_integrity_clone(clone, bio, GFP_NOIO, bs);
>> -
>> +#if 0
>> +     if (bio_integrity(bio))
>>               if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
>>                       bio_integrity_trim(clone,
>>                                          bio_sector_offset(bio, idx, 0), len);
>> -     }
>> -
>> +#endif
>
> Dead/debug code under "#if 0" ?
>
> Thanks
> Vivek
