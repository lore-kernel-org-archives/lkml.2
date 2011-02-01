Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1BAQdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:33:10 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57944 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1BAQdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:33:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Iz35jZxMFzvBTnqGjzDMhI1Sv0XPABUUGFyasbWuucES9WIHuKBbx9OdkA6KdNf6s2
         1Jm8L93lJNNkguu8F2cs+XkTBMCcsUyfWEvF5W/sdKC1uPkFWfgR+7k4MujPuQ7M16LW
         QLgvvkAknhuQ9rHPYXshq4SqLNDzUwWW8yFus=
MIME-Version: 1.0
In-Reply-To: <1296575975.12605.18.camel@moss-pluto>
References: <1296519474-15714-1-git-send-email-lucian.grijincu@gmail.com>
 <1296572538.12605.4.camel@moss-pluto> <AANLkTimiV_2SAwXuH-SjGav5XJixN=SnjrPrtFRRQF05@mail.gmail.com>
 <1296575975.12605.18.camel@moss-pluto>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Tue, 1 Feb 2011 18:32:46 +0200
Message-ID: <AANLkTi=wAXO0+gC=Cvh8EcJKOQW6-LSuO_tm2MsrtQQ6@mail.gmail.com>
Subject: Re: [PATCH] security/selinux: fix /proc/sys/ labeling
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Nick Piggin <npiggin@kernel.dk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 5:59 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>> Just the earlier one. I added his sign-off because of this paragraph
>> in SubmittingPatches:
>> | The Signed-off-by: tag indicates that the signer was involved in the
>> | development of the patch, or that he/she was in the patch's delivery path.


So should I leave Eric's sign-off here?


>> Without we label all nodes in /proc/ through selinux_proc_get_sid.
>>
>> /proc/1/limits should not get it's sid from here, but from
>> security_task_to_inode -> selinux_task_to_inode.
>>
>> Without the check we send "/1/limits" to selinux_proc_get_sid, which
>> strips off "/1" leaving "/limits". This will be labeled with "proc_t"
>> IIRC.
>
> Are you sure?  Those inodes should be labeled by proc_pid_make_inode()
> -> security_task_to_inode() -> selinux_task_to_inode(), which will set
> the inode SID to match the associated task SID, and set the
> isec->initialized flag.  Then when inode_doinit_with_dentry gets called
> later, it should bail immediately due to isec->initialized already being
> set.



I'll post an updated patch without those checks. I tested and 'find
/proc | xargs ls -Z' said the same thing with and without those
checks.

I remember doing the same test yesterday and saw some differences, but
I must have compared the wrong files.

-- 
 .
..: Lucian
