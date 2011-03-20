Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab1CTR76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 13:59:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54785 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab1CTR7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 13:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CAI8bj6AuUTGrwb/dfqaxjeOqi9XD6w2Hx8rghuIrTiIzM2tS+Iy0ebf/nY6cdjb6V
         06W+qd7LnCw1W62Dn2l0J+UYH+V9vX4591TNWaoOocOP7d52lKjvtBQwC3ZoVQI0ivx1
         Q7JtL+DYxbTFT+atBO3aXCX27bGeb034KU+qM=
MIME-Version: 1.0
In-Reply-To: <871v21x5d2.fsf@linux.vnet.ibm.com>
References: <1300291849-26257-1-git-send-email-mohan@in.ibm.com>
	<871v21x5d2.fsf@linux.vnet.ibm.com>
Date: Sun, 20 Mar 2011 12:59:52 -0500
Message-ID: <AANLkTi=ajNeb86B60FEgfuioyB6hKwctwYkQB2Y3CC-W@mail.gmail.com>
Subject: Re: [V9fs-developer] [PATCH V2] fs/9p: Use updated offset for writing
From: Eric Van Hensbergen <ericvh@gmail.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "M. Mohan Kumar" <mohan@in.ibm.com>, v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, probably a good idea, if we don't make it in time these are
actually fixes so we can bring them in during -rc1.

On Sun, Mar 20, 2011 at 8:56 AM, Aneesh Kumar K. V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Wed, 16 Mar 2011 21:40:49 +0530, "M. Mohan Kumar" <mohan@in.ibm.com> wrote:
>> Use the updated offset given by generic_write_checks. Without this fix,
>> even if a file is opened in O_APPEND mode, data will be written at current
>> file position instead of end of file.
>>
>> Signed-off-by: M. Mohan Kumar <mohan@in.ibm.com>
>
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>
> Eric,
>
> I guess this should go in this merge window ?
>
>> ---
>>  fs/9p/vfs_file.c |    7 +++++--
>>  1 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
>> index 6997eb6..ffed558 100644
>> --- a/fs/9p/vfs_file.c
>> +++ b/fs/9p/vfs_file.c
>> @@ -508,9 +508,12 @@ v9fs_file_write(struct file *filp, const char __user * data,
>>       if (!count)
>>               goto out;
>>
>> -     return v9fs_file_write_internal(filp->f_path.dentry->d_inode,
>> +     retval = v9fs_file_write_internal(filp->f_path.dentry->d_inode,
>>                                       filp->private_data,
>> -                                     data, count, offset, 1);
>> +                                     data, count, &origin, 1);
>> +     /* update offset on successful write */
>> +     if (retval > 0)
>> +             *offset = origin;
>>  out:
>>       return retval;
>>  }
>
> ------------------------------------------------------------------------------
> Colocation vs. Managed Hosting
> A question and answer guide to determining the best fit
> for your organization - today and in the future.
> http://p.sf.net/sfu/internap-sfd2d
> _______________________________________________
> V9fs-developer mailing list
> V9fs-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/v9fs-developer
>
