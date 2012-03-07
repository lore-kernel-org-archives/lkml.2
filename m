Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031728Ab2CGAti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:49:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:1062 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1031593Ab2CGAth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:49:37 -0500
X-IronPort-AV: E=Sophos;i="4.73,542,1325433600"; 
   d="scan'208";a="4473447"
Message-ID: <4F56B068.1080002@cn.fujitsu.com>
Date: Wed, 07 Mar 2012 08:48:40 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, sds@tycho.nsa.gov
Subject: Re: [PATCH] selinux: init target class when add avc callback
References: <1328406808-11309-1-git-send-email-gaowanlong@cn.fujitsu.com>  <4F56A4E2.5050001@cn.fujitsu.com>  <20120306161543.63c3fc54.akpm@linux-foundation.org> <1331080893.6253.1.camel@localhost>
In-Reply-To: <1331080893.6253.1.camel@localhost>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 08:47:39,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 08:47:40,
	Serialize complete at 2012-03-07 08:47:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2012 08:41 AM, Eric Paris wrote:

> On Tue, 2012-03-06 at 16:15 -0800, Andrew Morton wrote:
>> On Wed, 07 Mar 2012 07:59:30 +0800
>> Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
>>
>>> On 02/05/2012 09:53 AM, Wanlong Gao wrote:
>>>
>>>> Target security class should be initialized when add avc callback.
>>>> Although tclass is userless in callbacks now, but it may be used
>>>> in the future .
>>>>
>>>> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
>>>> ---
>>>>  security/selinux/avc.c |    1 +
>>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/security/selinux/avc.c b/security/selinux/avc.c
>>>> index dca1c22..27495e6 100644
>>>> --- a/security/selinux/avc.c
>>>> +++ b/security/selinux/avc.c
>>>> @@ -576,6 +576,7 @@ int avc_add_callback(int (*callback)(u32 event, u32 ssid, u32 tsid,
>>>>  	c->events = events;
>>>>  	c->ssid = ssid;
>>>>  	c->tsid = tsid;
>>>> +	c->tclass = tclass;
>>>>  	c->perms = perms;
>>>>  	c->next = avc_callbacks;
>>>>  	avc_callbacks = c;
>>
>> Perhaps James can take a look at this?
>>
>> avc_add_callback() looks a bit odd.  It uses GFP_ATOMIC, but that is
>> unnecessary because avc_add_callback() is only ever called from
>> module_init() code.  And if it isn't only ever called from
>> module_init() code then it needs some locking for that list.
> 
> I'm a bad maintainer.  I should have done something with this patch.
> Adding sds, the only other person who ever actually maintains this code,
> to the thread.
> 
> __initcall() functions aren't serialized?  I guess that would be bad and
> we would need a lock.  I wonder if there are other places I assumed
> __initcall() would be serialized (note that all of these call sites are
> built in and not modules if that makes a difference)
> 
> I'll probably just rip all of that ssid, tsid, tclass, perms, stuff out.
> If all these years noone uses callbacks for anything other than reset
> why do we have it at all.  Probably more simplification we can do around
> avc_update_node() too...


Agree, seems that no one will use callbacks other than reset.

-Gao

> 
> Stephen, thoughts on ripping stuff out?
> 
> -Eric
> 
> 


