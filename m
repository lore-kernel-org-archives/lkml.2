Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab1IUFt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 01:49:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59452 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab1IUFty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 01:49:54 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <804BB4B7-E19F-41EE-81A3-25D4389B54B9@dilger.ca>
References: <1289840876-3546-1-git-send-email-josef@redhat.com>
 <CAKgNAkj-jPR-9hyuxrJ74uu3Kdv9bATrfCUedoty4dJOCh2GcA@mail.gmail.com>
 <CAKgNAkhCptHn_UxReeZeSNaP0yNr+iWYd3fcxrD_PHohqQVxuQ@mail.gmail.com> <804BB4B7-E19F-41EE-81A3-25D4389B54B9@dilger.ca>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Wed, 21 Sep 2011 07:49:33 +0200
Message-ID: <CAKgNAkiGp7stGdxFPgH973gaEwSN28H0uEx4NkNq-ub96Xw=tA@mail.gmail.com>
Subject: Re: [PATCH] fallocate.2: add FALLOC_FL_PUNCH_HOLE flag definition
To: Andreas Dilger <adilger@dilger.ca>
Cc: Josef Bacik <josef@redhat.com>, Eric Gouriou <egouriou@google.com>,
        inux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <dchinner@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

On Wed, Sep 21, 2011 at 7:25 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> On 2011-09-20, at 10:11 PM, Michael Kerrisk wrote:
>> Thanks for this patch. As noted in another mail, Lucian also sent a
>> patch for FALLOC_FL_PUNCH_HOLE, and I applied his patch first, and
>> then added some pieces from yours, as well as some of my own edits.
>>
>> However, the addition of a second class of operation to the man page
>> made it clear that some significant restructuring of the page is
>> required. So I substantially reworked the page, including the
>> preexisting material on the default "file allocation" operation (Dave
>> C please note).
>>
>>  .TP
>> .B EINVAL
>> .I offset
>> was less than 0, or
>> .I len
>> was less than or equal to 0.
>
> I wasn't sure if this is a bug in the manpage or actually how it is done
> in the kernel, but it seems this is a kernel implementation issue...
>
> Does it make sense to return an error if len == 0?  That just adds extra
> complexity on the part of the application, and doesn't reduce complexity
> in the kernel (whether the kernel checks for len == 0 and returns 0 or
> -EINVAL is not any different).  read() and write() and malloc() all allow
> a length of zero to succeed, since applications may compute this length
> and sometimes it is zero.

Good point. I agree: for comfort of userspace application writers and
for consistency with related interfaces, len == 0 shouldn't be an
error.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
