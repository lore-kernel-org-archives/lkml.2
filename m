Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081Ab1EOROF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:14:05 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35096 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab1EOROD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:14:03 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Alex Davis <alex14641@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Possible coding issue in udf??
References: <367853.39582.qm@web130121.mail.mud.yahoo.com>
X-Yow: ..The TENSION mounts as I MASSAGE your RIGHT ANKLE according to
 ancient Tibetan ACCOUNTING PROCEDURES..are you NEUROTIC yet??
Date: Sun, 15 May 2011 19:13:59 +0200
In-Reply-To: <367853.39582.qm@web130121.mail.mud.yahoo.com> (Alex Davis's
	message of "Fri, 13 May 2011 19:57:20 -0700 (PDT)")
Message-ID: <m2pqnjevjc.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Davis <alex14641@yahoo.com> writes:

> In fs/udf/inode.c, line 1455, linux 2.6.35, there is the following code:
>
> 	udfperms = ((inode->i_mode & S_IRWXO)) |
> 		   ((inode->i_mode & S_IRWXG) << 2) |
> 		   ((inode->i_mode & S_IRWXU) << 4);
>
> Shouldn't we be shifting by 3 bits? i.e:
> 	udfperms = ((inode->i_mode & S_IRWXO)) |
> 		   ((inode->i_mode & S_IRWXG) << 3) |
> 		   ((inode->i_mode & S_IRWXU) << 6);

udfperms contains three bit fields of 5 bits each, of which 3 bits are
each filled from one of the three RWX parts of i_mode, and 2 bits
(DELETE and CHATTR) are added later.  Thus each of the three bit fields
are expanded from 3 to 5 bits, so that the second one needs to be
shifted by 2 and the third one by 4.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
