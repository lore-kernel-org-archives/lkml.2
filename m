Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab2DZAvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 20:51:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35100 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704Ab2DZAu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 20:50:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120425222819.GF8989@google.com>
References: <CAHnt0GXW-pyOUuBLB1n6qBP4WNGpET9er_HbJ29s5j5DE1xAdA@mail.gmail.com>
	<20120425222819.GF8989@google.com>
Date: Thu, 26 Apr 2012 08:50:58 +0800
Message-ID: <CAHnt0GWABX8qOVTinmSETUHxq1Y3NhqPOKxnUgcDtyf8wjtg_g@mail.gmail.com>
Subject: Re: [BUG]memblock: fix overflow of array index
From: Peter Teoh <htmldeveloper@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply.   Just an educational question:  is it possible
to set one-byte per memblock?    And what is the minimum memblock
size?

Even if 2G memblock is a huge number, it still seemed like a bug to me
that there is no check on the maximum number (which is 2G) of this
variable (assuming signed int).   Software can always purposely push
that number up and the system can panic?

On Thu, Apr 26, 2012 at 6:28 AM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Apr 25, 2012 at 04:30:19PM +0800, Peter Teoh wrote:
>> Fixing the mismatch in signed and unsigned type assignment, which
>> potentially can lead to integer overflow bug.
>>
>> Thanks.
>>
>> Reviewed-by: Minchan Kim <minchan@kernel.org>
>> Signed-off-by: Peter Teoh <htmldeveloper@gmail.com>
>
> All indexes in memblock are integers.  Changing that particular one to
> unsigned int doesn't fix anything.  I think it just makes things more
> confusing.  If there ever are cases w/ more then 2G memblocks, we're
> going for 64bit not unsigned.
>
> Thanks.
>
> --
> tejun



-- 
Regards,
Peter Teoh
