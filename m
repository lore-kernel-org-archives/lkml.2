Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab1JAUq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:46:27 -0400
Received: from mail.anarazel.de ([217.115.131.40]:46719 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab1JAUqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:46:20 -0400
From: Andres Freund <andres@anarazel.de>
To: Andi Kleen <andi@firstfloor.org>, robertmhaas@gmail.com
Subject: Re: Improve lseek scalability v3
Date: Sat, 1 Oct 2011 22:46:13 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc8-andres-00005-gb7b65ee; KDE/4.6.5; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110012246.13801.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, September 16, 2011 01:06:46 AM Andi Kleen wrote:
> v3: No changes, except rebase. All reviews passed. Just reposting
> for merging.
Is anything/anyone still objecting to this patchset?

I just retested it ontop of v3.1-rc8 minus the btrfs parts (which don't apply 
cleanly anymore because a modified version of 1/7 was merged) and it works 
fine for some hours of fs heavy db using benchmarking/development.

Following is a seemingly trivial forward-port of 7/7. But since I have 
about no clue in fs development and even less about brfts - which I never used -
take it with a grain of salt.
It seems a bit ugly to have the mutex_unlock at three places btw. A 2nd patch
fixes that, no idea whether its worth the churn.
Both are compile tested only.

Even at this (2 x E5520 (4 cores)) machine there seems to be a benefit of 
about 1.5%. Not enough cores to get into the actually problematic performance 
areas as presented by Robert though.
The variance between runs is a bit too high to call it reliable though.

Thanks,

Andres


PS: I have no clue what to do with the s-o-b and changelog when forward 
porting a patch... So I just copied the original message - which seems wrong.

