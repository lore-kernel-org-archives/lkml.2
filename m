Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab0JHJOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:14:30 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59617 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab0JHJO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DwdQHUEuIYzN2ahmehIU7saHJd6AfV5HvHZFwugP92WqQhksAR6BAiUadegSPFGmuf
         Wv5lmqW06yDlS6q7sYsB6JJcdCO0JA/mD+zn88OAC3QZGMel+1nSWyE96ygEebVaXEnC
         f4TxNsP+n6nS4o6R4MrFeLUd8sBUnhwIbhhQw=
MIME-Version: 1.0
In-Reply-To: <20101008082231.GA2054@lst.de>
References: <20101006083150.GA15758@zhongling>
	<201010071431.14937.phillips@phunq.net>
	<20101008082231.GA2054@lst.de>
Date: Fri, 8 Oct 2010 17:14:27 +0800
Message-ID: <AANLkTim9KFuP1_mrUUsMOEspxkfA=SZW2dmTX4WJbfep@mail.gmail.com>
Subject: Re: introduce dm-snap-mv
From: McPacino <mcpacino@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

I have to take care the cache problem If using the bio directly.
BHs can be released by kernel when necessary.

Is there any existing code using bio to read/write metadata
blocks? How do they handle the timing freeing bios? I really
wish to learn something form it.

Regards.

Cong Meng.



On Fri, Oct 8, 2010 at 4:22 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Oct 07, 2010 at 02:31:14PM -0700, Daniel Phillips wrote:
>> Hi Meng,
>>
>> The patch looks sensible, however the question is: why do you want to
>> do this?  Would it not be better to generalize your metadata format to
>> accomodate the device's native blocksize?
>
> Even if it uses fixed 4k sectors it should just read them in smaller
> chunks OR even better stop using buffer heads and just read them
> manually using submit_bio.  BHs really shouldn't be used outside of
> filesystems, and even there they slowly are on their way out.
>
>
