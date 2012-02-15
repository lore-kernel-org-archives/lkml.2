Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab2BOL0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 06:26:47 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34724 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab2BOL0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 06:26:46 -0500
MIME-Version: 1.0
In-Reply-To: <20120215064059.GO4141@mwanda>
References: <1329272406-26198-1-git-send-email-jorgyano@gmail.com>
	<20120215064059.GO4141@mwanda>
Date: Wed, 15 Feb 2012 09:26:45 -0200
Message-ID: <CABRD5hLWn_hxC-ZzDJycw4=hDVuOiUiwxaz5Ljuxbgk1KAkpGw@mail.gmail.com>
Subject: Re: [PATCH] Staging: crystalhd: crystalhd_misc: improved debug macros
From: Jorgyano vieira <jorgyano@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 4:40 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Wed, Feb 15, 2012 at 12:20:06AM -0200, Jorgyano Vieira wrote:
>> Improvement of debug macros to ensure safe use on if/else statements.
>>
>
> How are the originals unsafe?
for example If you have something like:
if(foo)
        BCMLOG(...);
else
       do that

> Really we want to get rid of these.  It would be easy to delete
> BCMLOG_ENTER and BCMLOG_LEAVE right now.  They're only used for five
> functions.  BCMLOG() is slightly complicated.  BCMLOG_ERR() could
> be sed replaced with pr_err().
>
> So could you do that instead?  Send a patch to remove BCMLOG_ENTER
> and BCMLOG_LEAVE?  Then send another patch to replace BCMLOG_ERR()
> with pr_err().  Take a look at how the pr_fmt macro is used for
> this.  Don't actually do it with sed.  Take the time and review each
> printk() and notice bugs as you go along.  You could replace them
> file by file if you wanted or all at once, which ever is easier for
> you.  Then send a third patch to add the do {} while(0) block to
> BCMLOG() until someone works up enough motivation to fix it
> properly?
yes, this patch don't make the entire work,
I intend to make the remaining work on the next patches.
thanks for the suggestions.

regards,
Jorgyano Vieira
