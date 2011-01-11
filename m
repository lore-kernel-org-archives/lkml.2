Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab1AKQEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:04:32 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41493 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab1AKQEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:04:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n3KqJLSa05DAZYy/x2tE0WaXuI+jsL92rhQAUhJ7W/CHRTzkRugfFA5uayPKh1bjA2
         ldfkwfWOwTR/bmNCkyHLU0fLYKtmYtxNd1KJZlWwWTX4xkdyo/j8bz8dLBdYmZUiH0Ro
         koUQiioJzq0SIQ1O441AGB2Nqar3KixBmhByo=
Date: Wed, 12 Jan 2011 00:04:37 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Dave Anderson <anderson@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH] /proc/kcore: fix seeking
Message-ID: <20110111160437.GF17312@hack>
References: <4D2B1AD5.9000707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2B1AD5.9000707@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 09:42:29AM -0500, Dave Anderson wrote:
>From: Dave Anderson <anderson@redhat.com>
>
>Commit 34aacb2920667d405a8df15968b7f71ba46c8f18
>("procfs: Use generic_file_llseek in /proc/kcore")
>broke seeking on /proc/kcore.  This changes it back
>to use default_llseek in order to restore the original
>behavior.
>
>The problem with generic_file_llseek is that it only
>allows seeks up to inode->i_sb->s_maxbytes, which is
>2GB-1 on procfs, where the memory file offset values in
>the /proc/kcore PT_LOAD segments may exceed or start
>beyond that offset value.
>

Is the race solved? Using default_llseek() still races
with read_kcore() on fpos, AFAIK.


-- 
Live like a child, think like the god.
 
