Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab2CHWdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:33:41 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42941 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab2CHWdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:33:35 -0500
MIME-Version: 1.0
In-Reply-To: <m1aa3qwyz6.fsf@fess.ebiederm.org>
References: <1329777830-2942-1-git-send-email-masami256@gmail.com>
	<m11up2zu03.fsf@fess.ebiederm.org>
	<20120308211406.GA24445@kroah.com>
	<m1aa3qwyz6.fsf@fess.ebiederm.org>
Date: Fri, 9 Mar 2012 07:33:34 +0900
Message-ID: <CACOXgS_HApD4PQVJyb=C+Oymhs02ztOuJy7ng=eNNXHJ8isBeg@mail.gmail.com>
Subject: Re: [PATCH] Fix memory leak in sysfs_sd_setsecdata().
From: Masami Ichikawa <masami256@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Eric, thank you for the review.
Greg, thenk you for apply my patch.

On Fri, Mar 9, 2012 at 6:43 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
>
>> On Thu, Mar 08, 2012 at 01:02:20PM -0800, Eric W. Biederman wrote:
>>> Masami Ichikawa <masami256@gmail.com> writes:
>>>
>>> > This patch fixies follwing two memory leak patterns that reported by kmemleak.
>>> > sysfs_sd_setsecdata() is called during sys_lsetxattr() operation.
>>> > It checks sd->s_iattr is NULL or not. Then if it is NULL, it calls
>>> > sysfs_init_inode_attrs() to allocate memory.
>>> > That code is this.
>>>
>>> I don't know how you count two memory leaks.  But there is definitely a
>>> leak here sd->s_iattr is allocated and then never assigned.  It looks
>>> like I introduced that leak when I re-factored the code to protect
>>> the code with sysfs_mutex at the end of 2009.
>>>
>>> I am surprise the securlity label crowd has not been screaming about
>>> selinux protection not working on sysfs for the last two years.
>>>
>>> I have reviewed the code and the fix looks obvious and correct.
>>>
>>> Greg can you pick this up?
>>
>> I applied it a while ago to my tree already :)
>
> Odd I didn't see it linux-next when I looked an hour or so ago.
>
> As long as it is there and it makes it to stable.
>
> Eric
>
I saw my patch in linux-next tree.
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=93518dd2ebafcc761a8637b2877008cfd748c202

Cheers,
-- 
Masami Ichikawa
gmail: masami256@gmail.com
Fedora project: masami@fedoraproject.org
