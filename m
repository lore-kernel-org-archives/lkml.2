Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0ILR22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 13:28:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34088 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab0ILR21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 13:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=gmZRXu+fKZUfSiXI8p1l8DKIwGKPuNXwkQ14EplwM5w6TNwFPUpbmyR5A3CSQSULhN
         cceD5SEDcaaQ6/xzauah+R+yBrLzy9kAgyhL+dv8X8Y9xi8jLGai7vt+ZrtcGR8DfxtG
         w7kmrgLCBGqdmduomjmuZPglTIiTxlAI6gfGU=
MIME-Version: 1.0
In-Reply-To: <AANLkTinPWd2bavC_44WkEL++KXirZ1CW3dTNK7G-Oag=@mail.gmail.com>
References: <1284289340.2650.2.camel@ht.satnam>
	<20100912122955.GA28839@cmpxchg.org>
	<AANLkTinPWd2bavC_44WkEL++KXirZ1CW3dTNK7G-Oag=@mail.gmail.com>
Date: Sun, 12 Sep 2010 10:28:25 -0700
X-Google-Sender-Auth: H4WwiTUK0sTtVW1JJ-lW9sYv3U8
Message-ID: <AANLkTikhp0HvT2=2m9U__tqSxZbJmrbSDX+7_ZOddddt@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: Remove useless condition
From: Mike Fedyk <mfedyk@mikefedyk.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <chris.mason@oracle.com>,
        linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 6:56 AM, Jaswinder Singh Rajput
<jaswinderlinux@gmail.com> wrote:
> Hello,
>
> On Sun, Sep 12, 2010 at 5:59 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> On Sun, Sep 12, 2010 at 04:32:20PM +0530, Jaswinder Singh Rajput wrote:
>>>
>>> if (ret) is useless as it will be never NULL as in previous statement
>>> we are setting ret = prev for !ret
>>
>> If there is no match and no extent below the given file offset, `prev'
>> will be NULL as well, no?
>>
>> So the check is not useless, it prevents throwing out a cached success
>> in case of a lookup failure.
>>
>
> Got it !!
>

Wouldn't it be clearer and easier to read if prev was checked directly
instead of checking ret after it becomes the same as prev?
