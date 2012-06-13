Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab2FMGYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 02:24:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2FMGYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 02:24:21 -0400
Message-ID: <4FD8320C.1060308@redhat.com>
Date: Wed, 13 Jun 2012 08:24:12 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com
Subject: Re: [PATCH 2/2] xfs: add FALLOC_FL_ZERO_RANGE to fallocate
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com> <1339515364-17374-3-git-send-email-pbonzini@redhat.com> <20120613021610.GQ22848@dastard>
In-Reply-To: <20120613021610.GQ22848@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/06/2012 04:16, Dave Chinner ha scritto:
>> > +	BUG_ON((mode & FALLOC_FL_PUNCH_HOLE) && (mode & FALLOC_FL_ZERO_RANGE));
> Never put BUG_ON() or BUG() in XFS code that can return an error.
> Return EINVAL if we chose not to support it, and if it's really
> something we consider bad, emit a warning to syslog (i.e.
> xfs_warn()) and potentially add a ASSERT() case so that debug
> kernels will trip over it. Nobody should be panicing a production
> system just because a user supplied a set of incorrect syscall
> paramters....

I know, the BUG_ON() is because it is ruled out in VFS code.  Of course
if I remove that code, this will not be a BUG_ON() anymore.

Paolo

