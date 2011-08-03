Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab1HCCSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 22:18:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47066 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1HCCSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 22:18:02 -0400
Message-ID: <4E38AFC2.3070608@gmail.com>
Date: Wed, 03 Aug 2011 10:17:38 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd/jbd2: add pointer type conversion on void *arg from
 void * to journal_t * explicitly in kjournald/kjournald2
References: <4E38AB50.9040804@gmail.com> <4E38AC92.4090501@cn.fujitsu.com>
In-Reply-To: <4E38AC92.4090501@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年08月03日 10:04, Li Zefan wrote:
> 09:58, Wang Sheng-Hui wrote:
>> The patch is against 3.0
>>
>> The arg of kjournald/kjournald2 is void *, and points to type
>> journal_t. We should convert it to journal_t * explicitly in
>> the kjournald/kjournald2 function body.
>>
> 
> Why?
> 
> Implicit convertion from void * to foo * is ok. Did the compiler
> complain about this to you?

I remember any * can be assigned directly to void * in ANSI C, but
void * should be converted to specific point * type. Right?

And I checked the code of kswapd, in which explicitly conversion is
taken on the arg *. I think it should do so in journal.c too.

> 
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>> ---
>>  fs/jbd/journal.c  |    2 +-
>>  fs/jbd2/journal.c |    2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
>> index e2d4285..32956fd 100644
>> --- a/fs/jbd/journal.c
>> +++ b/fs/jbd/journal.c
>> @@ -116,7 +116,7 @@ static void commit_timeout(unsigned long __data)
>>  
>>  static int kjournald(void *arg)
>>  {
>> -	journal_t *journal = arg;
>> +	journal_t *journal = (journal_t *)arg;
>>  	transaction_t *transaction;
>>  
>>  	/*
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index 0dfa5b5..c4f4bfc 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -129,7 +129,7 @@ static void commit_timeout(unsigned long __data)
>>  
>>  static int kjournald2(void *arg)
>>  {
>> -	journal_t *journal = arg;
>> +	journal_t *journal = (journal_t *)arg;
>>  	transaction_t *transaction;
>>  
>>  	/*

