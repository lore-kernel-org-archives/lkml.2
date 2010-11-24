Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0KXM3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 07:29:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47345 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab0KXM27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 07:28:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=an1nO6xKWAFQkMPSW+ZvQEUxAAouQUl8l5zwEriCRpylQ1Xz5nTvTHc0l+804u02Bf
         3DnxV0xXHUL7vB6b7FmWtsrCVIC+fSm6wN1rNbmCCFl7TqxQA/DrXgKSJiNjq3SCFlmZ
         vNz5PJmjQQ2Y7C398nXK2fNJRF22yAWYU+UAU=
Date: Wed, 24 Nov 2010 20:32:13 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?Q?P=C3=A1draig?= Brady <P@draigBrady.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, wharms@bfs.de,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>, kernel-janitors@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
Message-ID: <20101124123213.GB2922@hack>
References: <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca> <20101114092533.GB5323@albatros> <20101114180643.593d19ac.akpm@linux-foundation.org> <1289848341.2607.125.camel@edumazet-laptop> <20101123140111.GA3816@hack> <4CEBD37E.5060107@bfs.de> <203E1F2A-2D04-4B7F-8D1B-9DC24522CB5E@dilger.ca> <4CECECA2.6070301@draigBrady.com> <20101124110535.GD5139@cr0.nay.redhat.com> <4CECFB19.1090003@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CECFB19.1090003@draigBrady.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 11:46:33AM +0000, Pádraig Brady wrote:
>On 24/11/10 11:05, Américo Wang wrote:
>> On Wed, Nov 24, 2010 at 10:44:50AM +0000, Pádraig Brady wrote:
>>> On 23/11/10 18:02, Andreas Dilger wrote:
>>>> On 2010-11-23, at 07:45, walter harms wrote:
>>>>> Maybe we can convince the gcc people to make 0 padding default. That will not solve the problems for other compilers but when they claim "works like gcc" we can press then to support this also. I can imagine that this will close some other subtle leaks also.
>>>>
>>>> It makes the most sense to tackle this at the GCC level, since the added overhead of doing memset(0) on the whole struct may be non-trivial for commonly-used and/or large structures.  Since GCC is already explicitly zeroing the _used_ fields in the struct, it can much more easily determine whether there is padding in the structure, and zero those few bytes as needed.
>>>
>>> Zero padding structs is part of C90. Details here:
>>> http://www.pixelbeat.org/programming/gcc/auto_init.html
>> 
>> Nope.
>> 
>>>
>>> gcc doesn't zero pad when _all_ elements are specified.
>>>
>> 
>> That is what gcc does, not what C standard specifies.
>
>Looks like gcc is following the standard exactly.
>
>C90 - 6.5.7
>C99 - 6.7.8
>
>  If there are fewer initializers in a brace-enclosed list than
>  there are elements or members of an aggregate ... the remainder
>  of the aggregate shall be initialized implicitly the same as
>  objects that have static storage duration.
>

Depends on if "the remainder of the aggregate" includes padding bytes
or not.
