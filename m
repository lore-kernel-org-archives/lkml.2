Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab0GHNSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:18:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64620 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab0GHNSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:18:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH 18/18] vfs: make no_llseek the default
Date: Thu, 8 Jul 2010 15:18:28 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
       John Kacur <jkacur@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Julia Lawall <julia@diku.dk>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de> <201007081408.06415.arnd@arndb.de> <201007082157.IFC26590.JMQSHOFFFOVLtO@I-love.SAKURA.ne.jp>
In-Reply-To: <201007082157.IFC26590.JMQSHOFFFOVLtO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007081518.28738.arnd@arndb.de>
X-Provags-ID: V02:K0:T1DrmePL2xs4JrXMff7heZk2VkWGEMwvdqmoU0L04wu
 PgbV+LuWdBVx7w7Kv7CZJYcuawFkkDaUyAvTgRw1C2jgOlkU6X
 tht2AE43tLPX8yiWGizWNvxe7q6HNFqbnMIyYa9I04kiz3xvgK
 E6q88RSx/Kcg5EteCxe6Imd0whOaYCl0oz+f6vXozVQsSiMcF9
 +HLaz5CXn21JocYxwX+wA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 July 2010, Tetsuo Handa wrote:
> I see. [PATCH 16/18] ( http://lkml.org/lkml/2010/7/7/258 ) contains a line
> 
>    security/tomoyo/common.c                      |    1 +
> 
> but no change in the patch. Patch was too large?

Yes, the total patch is almost 200kb, which I considered too large.
I explained this in the changelog.

In retrospect, I probably should have sent it all anyway, because the
changelog is already very long and a few other people did not realize
this either because they did only read the patch but not the changelog.

As I mentioned to Boaz Harrosh, the full patch is available on
http://git.kernel.org/?p=linux/kernel/git/arnd/bkl.git;a=patch;h=dc731e01d2a08eb66ae08c226c97aa0cb8cf7b7f
and I'll send it out completely if I send out the series again.

I first want to make sure we have consensus on the semantic patch though.
In particular, I want to be sure everyone agrees on the following questions:

- should we kill default_llseek in favour of a more generic generic_file_llseek
  that also covers special files?
- if not, should default_llseek get renamed to something else?
- should I bother adding .llseek=no_llseek if we make that the default in the
  next step anyway?
- should I drop all the automatically generated comments?
- Do I need to split this patch up into per-maintainer chunks and send them
  through the individual trees, or do we just apply the semantic patch treewide
  at the end of the merge window?

	Arnd
