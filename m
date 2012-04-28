Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2D1TFB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 15:05:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab2D1TFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 15:05:00 -0400
Date: Sat, 28 Apr 2012 12:06:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasikanth babu <sasikanth.v19@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memblock - Handled failure of debug fs entries
 creation
Message-Id: <20120428120657.4982a248.akpm@linux-foundation.org>
In-Reply-To: <CAOJFanUu_RD2UNgFg4gNuPte+jOA95ejMtq53UCo6vLaLohmQQ@mail.gmail.com>
References: <1335383992-19419-1-git-send-email-sasikanth.v19@gmail.com>
	<20120426162108.b654a920.akpm@linux-foundation.org>
	<CAOJFanUu_RD2UNgFg4gNuPte+jOA95ejMtq53UCo6vLaLohmQQ@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2012 00:32:26 +0530 Sasikanth babu <sasikanth.v19@gmail.com> wrote:

> > Fact is, debugfs_create_dir() and debugfs_create_file() are stupid
> > interfaces which don't provide the caller (and hence the user) with any
> > information about why they failed.  Perhaps memblock_init_debugfs()
> > should return -EWESUCK.
> >
> 
>    I'm working on a patch which address this issue. debugfs_create_XXX
> calls
>    will return proper error codes, and fixing the existing code not each
> and every part  but the code
>    which handles the values returned by debufs_create_XXX otherwise it will
> break the existing
>    functionality .

Excellent!

> (any suggestions or opinions ?)

Well, don't modify the existing interfaces: create new ones and we can
migrate gradually.  But you're probably already doing that.
