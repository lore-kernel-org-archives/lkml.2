Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089Ab0EMP1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:27:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751590Ab0EMP1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:27:37 -0400
Date: Thu, 13 May 2010 08:24:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] vfs: Fix O_NOFOLLOW behavior for paths with trailing
 slashes
In-Reply-To: <1273747977-4579-1-git-send-email-jack@suse.cz>
Message-ID: <alpine.LFD.2.00.1005130823370.3711@i5.linux-foundation.org>
References: <1273747977-4579-1-git-send-email-jack@suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 May 2010, Jan Kara wrote:
>
> According to specification
> mkdir d; ln -s d a; open("a/", O_NOFOLLOW | O_RDONLY)
> should return success but currently it did return ELOOP. Fix the code to ignore
> O_NOFOLLOW in case the provided path has trailing slashes. This is a regression
> caused by path lookup cleanup patch series.
> 
> CC: stable@kernel.org

Hmm? Is this correct? Isn't the bug introduced in this merge window, and 
thus not relevant for stable?

		Linus
