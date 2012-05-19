Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab2ESUOe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 16:14:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46619 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab2ESUOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 16:14:33 -0400
Date: Sat, 19 May 2012 15:14:18 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Szymon Janc <szymon@janc.net.pl>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] binfmt_misc: Fix compilation error in parse_command()
Message-ID: <20120519201418.GA5780@burratino>
References: <1327172558-19180-1-git-send-email-szymon@janc.net.pl>
 <20120121191806.GD23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120121191806.GD23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Sat, Jan 21, 2012 at 08:02:37PM +0100, Szymon Janc wrote:

>> --- a/fs/binfmt_misc.c
>> +++ b/fs/binfmt_misc.c
>> @@ -418,7 +418,7 @@ static int parse_command(const char __user *buffer, size_t count)
>>  		return 0;
>>  	if (count > 3)
>>  		return -EINVAL;
>> -	if (copy_from_user(s, buffer, count))
>> +	if (copy_from_user(s, buffer, min(count, sizeof(s))))
>
> File a report in gcc bugzilla.  Note that
> 	* count is size_t and thus unsigned
> 	* sizeof(s) is 4
> IOW, min(count, sizeof(s)) should do no better (or worse) than count here.
> If gcc is unable to prove that, it really needs to be fixed...

Looks like this is <http://gcc.gnu.org/PR52798>.

Thanks,
Jonathan
