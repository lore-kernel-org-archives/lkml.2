Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1FBNvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:51:37 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61111 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab1FBNvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:51:35 -0400
MIME-Version: 1.0
In-Reply-To: <m1y61kfj2a.fsf@fess.ebiederm.org>
References: <1306934105-6280-1-git-send-email-lucas.demarchi@profusion.mobi>
 <alpine.LNX.2.00.1106011521160.12980@swampdragon.chaosbits.net>
 <BANLkTimnn8hAw7VqgbTTgheREox5DJBhcQ@mail.gmail.com> <m1y61kfj2a.fsf@fess.ebiederm.org>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Thu, 2 Jun 2011 10:51:15 -0300
Message-ID: <BANLkTimu68E0_U0w8XAtLQztHY6vJqkPVQ@mail.gmail.com>
Subject: Re: [PATCH] sysctl: remove impossible condition check
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 10:40 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>> Looking again at the code, I'm wondering if this is not actually a
>> bug. There might be entries with procname == NULL, meaning they are
>> not mirrored in /proc. What seems wrong is the condition in the for().
>> It should stop when all fields are 0 (meaning the end of the table)
>> instead of stopping when procname is NULL.
>
> It is not a bug.  The condition was originally p->ctlname then
> it became p->ctlname || p->procname and then finally I was able to
> kill ctl_name.
>
> What you see is a left over that didn't get removed.
>

Alright then.

> This is also the second time in the last couple of weeks someone has
> sent this patch.
>
> There is some ongoing work to make sysctl scale better that with
> any luck should be ready for 3.1.  Decide which version of this
> patch you like and please resend, and I will add this to my
> sysctl tree.

There's also the same thing in this file, in scan() function. I'll add
it to the previous patch and resend.

thanks
Lucas De Marchi
