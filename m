Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835Ab2DKR6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:58:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59371 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759508Ab2DKR6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:58:35 -0400
Message-ID: <4F85C640.3060608@zytor.com>
Date: Wed, 11 Apr 2012 10:58:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com> <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com> <4F7F1864.8090606@zytor.com> <CAHGf_=rsJ8o8Fnd2z5Z8jHGc=cz370ay0_t3bhkiYRCBh3puVw@mail.gmail.com>
In-Reply-To: <CAHGf_=rsJ8o8Fnd2z5Z8jHGc=cz370ay0_t3bhkiYRCBh3puVw@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 05:09 PM, KOSAKI Motohiro wrote:
> 
> I know the reason. fcntl(F_NEXT) is one of a proposal of next SUS enhancement.
> 
>   http://austingroupbugs.net/view.php?id=149
> 
> nextfd() has a semantics of F_NEXT.
> 
> Next, why shoundn't we implement fcntl(F_NEXT) in our kernel? I think
> we have two reason.
> 
> 1) As linus pointed out, linux specific "flags" argument may be useful.
> 2) The name of F_NEXT is not fixed yet. another url of the austin says
> it is FD_NEXT.
>      So, we can't choose right name yet. Moreover, A meanings of 3rd
> argument of F_NEXT
>      haven't been fixed.
> 

But it still has the same braindamage: one system call per loop
invocation, and we can do better.  I would much rather see fdwalk() in SUS.

	-hpa

