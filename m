Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1HPTqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:46:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:57281 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1HPTqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:46:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=hNhqjJ+3BdRTBjWvFmfRUMk+dyyQgXFhzBXp57bAX9sT0Mxxy2LstF81Cap2cA8Dc
	GkF2WvdHwm8mNDurW8Qjg==
MIME-Version: 1.0
In-Reply-To: <20110816194050.GB4484@csn.ul.ie>
References: <1313441856-1419-1-git-send-email-wad@chromium.org>
 <20110816093303.GA4484@csn.ul.ie> <CAB=4xhqu1FsJnNbHNeokyROvEFpRJYKhcHRLLw5QTVKOkbkWfQ@mail.gmail.com>
 <20110816194050.GB4484@csn.ul.ie>
From: Roland McGrath <mcgrathr@google.com>
Date: Tue, 16 Aug 2011 12:46:17 -0700
Message-ID: <CAB=4xhrStO=ec92KD2W6V3QzjgaET5jvF1PXdAdu_LdFg7G82Q@mail.gmail.com>
Subject: Re: [PATCH] mmap: add sysctl for controlling ~VM_MAYEXEC taint
To: Mel Gorman <mel@csn.ul.ie>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, Hugh Dickins <hughd@google.com>,
        Shaohua Li <shaohua.li@intel.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 12:40 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> They might result in the same system call but one of them creates
> the file under /dev/shm which should not have the same permissions
> problem. The library really appears to want to create a shared
> executable object, using shm_open does not appear that unreasonable
> to me.

People do use shm_open.  Some systems mount /dev/shm with noexec.
That's why we're here in the first place.

> Which then needs to be copied in each distro wanting to do the same
> thing and is not backwards compatible where as using shm_open is.

Each distro wanting to set noexec on its /dev/shm mounts has to set the
sysctl (or its default in their kernel builds), yes.  Otherwise they are
not compatible with the expectation of using PROT_EXEC on files opened with
shm_open.


Thanks,
Roland
