Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750894Ab2LVInz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 03:43:55 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:58728 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab2LVInx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 03:43:53 -0500
MIME-Version: 1.0
In-Reply-To: <20121222082933.GA26477@infradead.org>
References: <cover.1356124965.git.luto@amacapital.net> <6b22b806806b21af02b70a2fa860a9d10304fc16.1356124965.git.luto@amacapital.net>
 <20121222082933.GA26477@infradead.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 22 Dec 2012 00:43:30 -0800
Message-ID: <CALCETrX423Au=Q0SgdpFp7hcVBAw0t4FprO18Wk9j0K=j8fg_w@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm: Update file times when inodes are written
 after mmaped writes
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 12:29 AM, Christoph Hellwig <hch@infradead.org> wrote:
> NAK, we went through great trouble to get rid of the nasty layering
> violation where the VM called file_update_time directly just a short
> while ago, reintroducing that is a massive step back.
>
> Make sure whatever "solution" for your problem you come up with keeps
> the file update in the filesystem or generic helpers.
>

There's an inode operation ->update_time that is called (if it exists)
in these patches to update the time.  Is that insufficient?  I could
add a new inode operation ->modified_by_mmap that would be called in
mapping_flush_cmtime if that would be better.

The original version of this patch did the update in ->writepage and
->writepages, but that may have had lock ordering issues.  (I wasn't
able to confirm that there was any actual problem.)

--Andy
