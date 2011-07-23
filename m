Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab1GWU1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 16:27:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab1GWU1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 16:27:18 -0400
Message-ID: <4E2B2E88.8080006@redhat.com>
Date: Sat, 23 Jul 2011 16:26:48 -0400
From: Josef Bacik <josef@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@zeniv.linux.org.uk,
        jack@suse.cz, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Subject: Re: [PATCH] fs: push i_mutex and filemap_write_and_wait down into
 ->fsync() handlers
References: <1309370716-12235-1-git-send-email-josef@redhat.com> <20110723180942.GA1616@x4.trippels.de>
In-Reply-To: <20110723180942.GA1616@x4.trippels.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2011 02:09 PM, Markus Trippelsdorf wrote:
> On 2011.06.29 at 14:05 -0400, Josef Bacik wrote:
>> Btrfs needs to be able to control how filemap_write_and_wait_range() is called
>> in fsync to make it less of a painful operation, so push down taking i_mutex and
>> the calling of filemap_write_and_wait() down into the ->fsync() handlers.  Some
>> file systems can drop taking the i_mutex altogether it seems, like ext3 and
>> ocfs2.  For correctness sake I just pushed everything down in all cases to make
>> sure that we keep the current behavior the same for everybody, and then each
>> individual fs maintainer can make up their mind about what to do from there.
>
> At least the xfs part of this patch is broken.
> Running the latest git-kernel bogofilter doesn't work anymore on my xfs
> partition. When I run "bogoutil -d wordlist.db" to dump the contents of
> the database, it produces no output at all.
>

Already fixed and sent a patch out earlier this week.  Thanks,

Josef
