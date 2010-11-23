Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab0KWPUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:20:45 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49358 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab0KWPUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:20:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=C2kz3A6QtTni62bTHZAKEunfitUiW5sHP3ybADkHVqsKflRsQNfd2aIMCL2G7AIYAd
         9yE4c3pvHBNH/cMBqj4PB62dLVTNh0xi+uP5sooeF3k4Tp/Gd6knH5znvpi/yddnK9F9
         hBJe4mGuCmvcCa5B34jB2e/SN1GsH83sPSk8Q=
Date: Tue, 23 Nov 2010 23:23:55 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: walter harms <wharms@bfs.de>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        kernel-janitors@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
Message-ID: <20101123152355.GB3816@hack>
References: <1289421483-23907-1-git-send-email-segooon@gmail.com> <20101112120834.33062900.akpm@linux-foundation.org> <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca> <20101114092533.GB5323@albatros> <20101114180643.593d19ac.akpm@linux-foundation.org> <1289848341.2607.125.camel@edumazet-laptop> <20101123140111.GA3816@hack> <4CEBD37E.5060107@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CEBD37E.5060107@bfs.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 03:45:18PM +0100, walter harms wrote:
>Am 23.11.2010 15:01, schrieb Américo Wang:
>> On Mon, Nov 15, 2010 at 08:12:21PM +0100, Eric Dumazet wrote:
>>>
>>> In my understanding, gcc should initialize all holes (and other not
>>> mentioned fields) with 0, even for automatic storage [C99 only mandates
>>> this on static storage]
>>>
>>> I tested on x86_64 and this is the case, but could not find a definitive
>>> answer in gcc documentation.
>>>
>> 
>> Yeah, this is not clearly defined by C99 I think, but we can still
>> find some clues in 6.2.6.1, Paragraph 6,
>> 
>> "
>> When a value is stored in an object of structure or union type,
>> including in a member object, the bytes of the object representation
>> that correspond to any padding bytes take unspecified values.
>> "
>> 
>> So we can't rely on the compiler to initialize the padding bytes
>> too.
>> 
>hi all,
>as we see this is not a question of c99.
>Maybe we can convince the gcc people to make 0 padding default. That will not solve the
>problems for other compilers but when they claim "works like gcc" we can press then to
>support this also. I can imagine that this will close some other subtle leaks also.
>
>People that still want a "undefined" (for what ever reason) can use an option to enable it
>again (e.g.  --no-zero-padding).


Well, IMHO, the default behavior should be "undefined", thus
"-fzero-padding" is needed. But, you know, I am not a compiler
people at all. :)

>
>do anyone have a contact so we can forward that request ?
>

gcc@gcc.gnu.org ?

-- 
Live like a child, think like the god.
 
