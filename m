Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab1ELViV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:38:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56736 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759Ab1ELViR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C4CeOVBQRMnmVqFwyogx2RWrdwJhiGymtPX3n/+lVLAtgqCa0QBDfVT6/AdE00qtpo
         hDavIV/7b2Sst9AcsZFYKSpcjmUfyAfE06+pghv+hS8uMj3lkw7B4KPRAniFdgovV4B3
         ITjHK8LEg7x2t2X1kRaB/mc0u29ZUMUK19LTw=
MIME-Version: 1.0
In-Reply-To: <4DCC4F05.7010306@suse.cz>
References: <1d7d3b31c0da82ce8ce75778922155b7004a8f7e.1305224477.git.mfm@muteddisk.com>
	<4DCC4365.3030907@suse.cz>
	<BANLkTimKpJoUnoYx8gXi6KCYgVpnXno4ow@mail.gmail.com>
	<4DCC4F05.7010306@suse.cz>
Date: Thu, 12 May 2011 14:38:16 -0700
Message-ID: <BANLkTimrW=ZG2sGG1Q8QehSnh5rW1eBzGw@mail.gmail.com>
Subject: Re: [Resend PATCH] package: Makefile: fix perf target bug
From: matt mooney <mfmooney@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 2:20 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 12.5.2011 23:07, matt mooney wrote:
>> 2011/5/12 Michal Marek <mmarek@suse.cz>:
>>> On 12.5.2011 20:25, mfmooney@gmail.com wrote:
>>>> diff --git a/scripts/package/Makefile b/scripts/package/Makefile
>>>> index 1b7eaea..a32dc2d 100644
>>>> --- a/scripts/package/Makefile
>>>> +++ b/scripts/package/Makefile
>>>> @@ -118,10 +118,14 @@ perf-tar=perf-$(KERNELVERSION)
>>>>
>>>>  quiet_cmd_perf_tar = TAR
>>>>        cmd_perf_tar = \
>>>> -git archive --prefix=$(perf-tar)/ HEAD^{tree}                       \
>>>> -     $$(cat $(srctree)/tools/perf/MANIFEST) -o $(perf-tar).tar;  \
>>>> +git --git-dir=$(srctree)/.git --work-tree=$(srctree)                \
>>>
>>> Neither git archive not git rev-parse need the work tree, --git-dir=..
>>> is sufficient.
>>
>> Are you sure?
>
> Yes.
> $ cd /tmp
> $ git --git-dir=$HOME/linux-2.6/.git rev-parse HEAD
> e0a04b11e4059cab033469617c2a3ce2d8cab416
>

You are right about that command, but it doesn't use the source tree.
Do a git --git-dir=$HOME/linux-2.6/.git status from /tmp and see what
happens.

So do you want me to send a new patch without --work-tree= in git rev-parse?

-matt

-- 
GPG-Key: 9AFE00EA
