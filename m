Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab0KWDhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 22:37:18 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:40780 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0KWDhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 22:37:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tXD6Z+OrWNlh5jxBlTioO3a+J4g7yJRSQ3KRxrZp2p1t14QYlUAqmd6EoArMPRdGBl
         TZqyW6Ex2xhIhXVzyBFkc0OipwSipZ3wT0YTlDGZXOEks06Z6DIo1chXhfxGOt2vvBeL
         SFmttxG754b3iOM6o9qk30/aEGz4mZCw9bA6A=
Subject: Re: [PATCH 2/2] ext3: Add journal error check into ext3_rename()
From: Namhyung Kim <namhyung@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101122180501.GE5012@quack.suse.cz>
References: <1290151716-4041-1-git-send-email-namhyung@gmail.com>
	 <1290151716-4041-2-git-send-email-namhyung@gmail.com>
	 <20101122180501.GE5012@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 12:37:10 +0900
Message-ID: <1290483430.1857.43.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-11-22 (월), 19:05 +0100, Jan Kara:
>   Uhuh, why ext3_journal_revoke()? I expect you want to cancel the changes
> you possibly did to new_bh. ext3_journal_forget() is for that but even that
> doesn't necessarily do what you want because it could cancel also changes
> some unrelated operation did to the buffer. So the only way to really undo
> the change is to set new_de->inode and new_de->file_type to original
> values. Also since we already unlinked the inode from the old directory,
> I'm not sure it's even beneficial to undo linking it to the new one. So I'd
> just bail out as fast as we can and leave on fsck to handle the mess...
> 
> 								Honza

Right. I wanted cancel the changes but I wasn't sure what I did. Thanks
for the explanation. I'll send v2 soon.

-- 
Regards,
Namhyung Kim


