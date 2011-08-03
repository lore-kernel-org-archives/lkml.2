Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab1HCCDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 22:03:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62619 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab1HCCDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 22:03:51 -0400
Message-ID: <4E38AC92.4090501@cn.fujitsu.com>
Date: Wed, 03 Aug 2011 10:04:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd/jbd2: add pointer type conversion on void *arg from
 void * to journal_t * explicitly in kjournald/kjournald2
References: <4E38AB50.9040804@gmail.com>
In-Reply-To: <4E38AB50.9040804@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 10:02:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 10:02:51,
	Serialize complete at 2011-08-03 10:02:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

09:58, Wang Sheng-Hui wrote:
> The patch is against 3.0
> 
> The arg of kjournald/kjournald2 is void *, and points to type
> journal_t. We should convert it to journal_t * explicitly in
> the kjournald/kjournald2 function body.
> 

Why?

Implicit convertion from void * to foo * is ok. Did the compiler
complain about this to you?

> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/jbd/journal.c  |    2 +-
>  fs/jbd2/journal.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index e2d4285..32956fd 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -116,7 +116,7 @@ static void commit_timeout(unsigned long __data)
>  
>  static int kjournald(void *arg)
>  {
> -	journal_t *journal = arg;
> +	journal_t *journal = (journal_t *)arg;
>  	transaction_t *transaction;
>  
>  	/*
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 0dfa5b5..c4f4bfc 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -129,7 +129,7 @@ static void commit_timeout(unsigned long __data)
>  
>  static int kjournald2(void *arg)
>  {
> -	journal_t *journal = arg;
> +	journal_t *journal = (journal_t *)arg;
>  	transaction_t *transaction;
>  
>  	/*
