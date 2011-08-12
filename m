Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1HLKxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 06:53:11 -0400
Received: from mx2.parallels.com ([64.131.90.16]:44898 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab1HLKxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 06:53:04 -0400
Message-ID: <4E4505F9.1040609@parallels.com>
Date: Fri, 12 Aug 2011 07:52:41 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>,
        David Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/4] Per-container dcache size limitation
References: <1312504544-1108-1-git-send-email-glommer@parallels.com>
In-Reply-To: <1312504544-1108-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.54.7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2011 09:35 PM, Glauber Costa wrote:
> Hi,
>
> Since v1, there is not too much new here.
> I'm incorporating David's suggestion of calling the sb
> shrinker, which will, in effect, prune the icache and
> other sb related objects as well.
>
> I am also keeping the mount based interface, since I
> still believe it is the way to go. But I'm obviously
> still open for suggestions. Some small corrections
> were also made to it since v1. Specifically, bind
> mounts are not allowed to alter the original sb dcache
> size.
>
> Glauber Costa (4):
>    factor out single-shrinker code
>    Keep nr_dentry per super block
>    limit nr_dentries per superblock
>    parse options in the vfs level
>
>   fs/dcache.c              |   44 +++++++++++-
>   fs/namespace.c           |  105 ++++++++++++++++++++++++++
>   fs/super.c               |   16 ++++-
>   include/linux/dcache.h   |    4 +
>   include/linux/fs.h       |    3 +
>   include/linux/shrinker.h |    6 ++
>   mm/vmscan.c              |  185 ++++++++++++++++++++++++----------------------
>   7 files changed, 274 insertions(+), 89 deletions(-)
>
People,

Any comments on this? I think I addressed all the comments previously
made, and if there are no further requests, I think this is ready for
getting in. In case there are issues, please let me know so I can 
address them.

