Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab2EBV6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:58:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47488 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab2EBV6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:58:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120502153100.GA2777@kroah.com>
References: <1335963054-24750-1-git-send-email-sasikanth.v19@gmail.com>
	<20120502153100.GA2777@kroah.com>
Date: Thu, 3 May 2012 03:28:17 +0530
Message-ID: <CAOJFanXZEUfM4GQS62u4oR-KwywdLGOciOcgzmrM9zW+kOrXkg@mail.gmail.com>
Subject: Re: [PATCH] debugfs: New debugfs interface for creation of files,
 directory and symlinks
From: Sasikanth babu <sasikanth.v19@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 9:01 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, May 02, 2012 at 06:20:54PM +0530, Sasikantha babu wrote:
>> As we know the current debugfs file or directory or symlink creation
>> doesn't return proper error codes to the caller on failure. Because
>> of this caller and user could not able to find the exact reason of
>> the failure.
>
> And what is the problem with this?  Either the file is created or not,
> you really shouldn't care anymore than that.  It's not like you are
> going to retry the creation, or are you?
>
> Who really cares if the file is failed to be created?

 In most of cases I had observed caller of debufs_create_file or
 debufs_create_dir always returns -ENOMEM on failure, which is not true.
 I felt returning proper error code will help in figuring out the actual
 reason of the failure (for eg: it can be -EEXISTS based on the error
 caller can change the name of the file or dir)

>
>> As Andrew Morton suggested (http://www.spinics.net/lists/linux-mm/msg33617.html)
>> introduced new debugfs interface to create debugfs entries. Newer APIs
>> returns proper error codes(ERR_PTR) on failure.
>
> Again, why?  What root problem are you trying to solve here?

   The usage of debugfs throughout the kernel is not uniform especially the
   error handling scenarios. Some place it is IS_ERR validations , other place
   against NULL and some place ignoring the return value. Just tried to make it
   uniform.
>
> thanks,
>
> greg k-h
