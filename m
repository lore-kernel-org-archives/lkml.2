Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab1BGPal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:30:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48506 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab1BGPak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:30:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tz+xcxkwQYbWFLRKnQkKMFvz4UIERYgDHGNgHl593J/BHrPxhxH0GnrgnteNCBS5S9
         mEuwQQUwyETfRlwxzbQcOHwOApAGsf79G3XaWf/fo4R6z55rPLXpIbOKN1QggR2RM15t
         NnedTc1E6w1pzGMtNWYJEYz0ACo9ihzOdXE0M=
MIME-Version: 1.0
In-Reply-To: <1296928005-9529-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1296928005-9529-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Date: Mon, 7 Feb 2011 09:30:22 -0600
Message-ID: <AANLkTikNzCApqx3e-ahxFHmE=VccnCvKxu2FyYHimxHn@mail.gmail.com>
Subject: Re: [V9fs-developer] [RFC PATCH -V2 06/17] fs/9p: Add fid to inode in
 cached mode
From: Eric Van Hensbergen <ericvh@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 5, 2011 at 11:46 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> The fid attached to inode will be opened O_RDWR mode and is used
> for dirty page writeback only.
>
> FIXME!!: Should we make the fid owned by uid = 0
>

Good question, the idea was for the kernel to own the fid while the
cache needed it.  Although
its unlikely to ever be matched to anything else since its an "open"
fid (so it won't be a candidate
for a walk).  It might be more secure to have it owned by some special
constant (a NOUID which could be ~0)
and marks the fid as being owned by the client and no one else without
any sort of implication of authority/ownership.
We could then put a special check in the find fid code to ignore any
fids with NOUID.

      -eric
