Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab0JSSW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:22:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53745 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab0JSSW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:22:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oINivqU8lEUcsBc03pLoun7D9/INhTQ7Op6HQI56Po3MIXW6iueZCwYCjXvFA1wk9e
         n1lk1hL0+dhGJWNqCnZpubZq7gEEob1lL0VitsVGcgNNAFN4WtUB96oluQOLBxDWvnhV
         qqUd1eUNQ/3UY0fRz0j7hNdt88GhEDXz7QMZc=
MIME-Version: 1.0
In-Reply-To: <4CBDC419.8060909@kernel.org>
References: <4CBDBF8A.8010106@kernel.org>
	<20101019121319.16f06b76@corrin.poochiereds.net>
	<4CBDC419.8060909@kernel.org>
Date: Tue, 19 Oct 2010 13:22:56 -0500
Message-ID: <AANLkTi=mxgr2v3n8ZQYNtcBqK78LRUE6nF5Y20=VQDjz@mail.gmail.com>
Subject: Re: [PATCH v2.6.36-rc7] cifs: cancel_delayed_work() +
 flush_scheduled_work() -> cancel_delayed_work_sync()
From: Steve French <smfrench@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK - will add this to the cifs tree this afternoon.

On Tue, Oct 19, 2010 at 11:15 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 10/19/2010 06:13 PM, Jeff Layton wrote:
>> On Tue, 19 Oct 2010 17:55:54 +0200
>> Tejun Heo <tj@kernel.org> wrote:
>>
>>> flush_scheduled_work() is going away.
>>>
>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>> ---
>>>  fs/cifs/cifs_dfs_ref.c |    3 +--
>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> Index: work/fs/cifs/cifs_dfs_ref.c
>>> ===================================================================
>>> --- work.orig/fs/cifs/cifs_dfs_ref.c
>>> +++ work/fs/cifs/cifs_dfs_ref.c
>>> @@ -44,8 +44,7 @@ static void cifs_dfs_expire_automounts(s
>>>  void cifs_dfs_release_automount_timer(void)
>>>  {
>>>      BUG_ON(!list_empty(&cifs_dfs_automount_list));
>>> -    cancel_delayed_work(&cifs_dfs_automount_task);
>>> -    flush_scheduled_work();
>>> +    cancel_delayed_work_sync(&cifs_dfs_automount_task);
>>>  }
>>>
>>>  /**
>>
>> Looks like a better way to do this anyhow.
>>
>> Reviewed-by: Jeff Layton <jlayton@redhat.com>
>
> Yeah, way faster too.  It would be best to route this patch through
> cifs tree but I can push it through wq tree too.  Just let me know.
>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Thanks,

Steve
