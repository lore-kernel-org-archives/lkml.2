Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab2IGM6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:58:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab2IGM6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:58:08 -0400
Message-ID: <5049EF5B.3020607@draigBrady.com>
Date: Fri, 07 Sep 2012 13:58:03 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@poochiereds.net>
CC: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] procfs: don't need a PATH_MAX allocation to hold a string
 representation of an int
References: <1347021293-19052-1-git-send-email-jlayton@redhat.com> <20120907084814.07a59c98@corrin.poochiereds.net>
In-Reply-To: <20120907084814.07a59c98@corrin.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 01:48 PM, Jeff Layton wrote:
> On Fri,  7 Sep 2012 08:34:53 -0400
> Jeff Layton<jlayton@redhat.com>  wrote:
>
>> Signed-off-by: Jeff Layton<jlayton@redhat.com>
>> ---
>>   fs/proc/base.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index 1b6c84c..58e801b 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -2758,7 +2758,8 @@ static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
>>   	pid_t tgid = task_tgid_nr_ns(current, ns);
>>   	char *name = ERR_PTR(-ENOENT);
>>   	if (tgid) {
>> -		name = __getname();
>> +		/* 10 for max length of an int in decimal + NULL terminator */
>> +		name = kmalloc(11, GFP_KERNEL);
>
> 		^^^^^
> Bah...my mistake. This should be "12", since it's possible (though
> unlikely) that this value could be negative. Is there a better way to
> express "strlen of max representation of an int in decimal" ?

See INT_BUFSIZE_BOUND() in:
http://git.sv.gnu.org/gitweb/?p=gnulib.git;a=blob;f=lib/intprops.h;hb=HEAD

cheers,
Pádraig.
