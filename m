Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0KDIHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 04:07:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:47786 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab0KDIHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 04:07:53 -0400
Message-ID: <4CD26948.7050009@kernel.org>
Date: Thu, 04 Nov 2010 09:05:28 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kapil Arya <kapil@ccs.neu.edu>
CC: Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Gene Cooperman <gene@ccs.neu.edu>,
        hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>
In-Reply-To: <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Nov 2010 08:05:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/04/2010 04:40 AM, Kapil Arya wrote:
> (Sorry for resending the message; the last message contained some html
> tags and was rejected by server)

And please also don't top-post.  Being the antisocial egomaniacs we
are, people on lkml prefer to dissect the messages we're replying to,
insert insulting comments right where they would be most effective and
remove the passages which can't yield effective insults.  :-)

> In our personal view, a key difference between in-kernel and userland
> approaches is the issue of security.  The Linux C/R developers state
> the issue very well in their FAQ (question number 7):
>> https://ckpt.wiki.kernel.org/index.php/Faq :
>> 7. Can non-root users checkpoint/restart an application ?
>>
>> For now, only users with CAP_SYSADMIN privileges can C/R an
>> application. This is to ensure that the checkpoint image has not been
>> tampered with and will be treated like a loadable kernel-module.

That's an interesting point but I don't think it's a dealbreaker.
Kernel CR is gonna require userland agent anyway and access control
can be done there.  Being able to snapshot w/o root privieldge
definitely is a plust but it's not like CR is gonna be deployed on
majority of desktops and servers (if so, let's talk about it then).

> Strategies like these are easily handled in userspace.  We suspect
> that while one may begin with a pure kernel approach, eventually,
> one will still want to add a userland component to achieve this kind
> of flexibility, just as BLCR has already done.

Yeap, agreed.  There gotta be user agents which can monitor and
manipulate userland states.  It's a fundamentally nasty job, that of
collecting and applying application-specific workarounds.  I've only
glanced the dmtcp paper so my understanding is pretty superficial.
With that in mind, can you please answer some of my curiosities?

* As Oren pointed out in another message, there are somethings which
  could seem a bit too visible to the target application.  Like the
  manager thread (is it visible to the application or is it hidden by
  the libc wrapper?) and reserved signal.  Also, while it's true that
  all programs should be ready to handle -EINTR failure from system
  calls, it's something which is very difficult to verify and test and
  could lead to once-in-a-blue-moon head scratchy kind of failures.

  I think most of those issues can be tackled with minor narrow-scoped
  changes to the kernel.  Do you guys have things on mind which the
  kernel can do to make these things more transparent or safer?

* The feats dmtcp achieves with its set of workarounds are impressive
  but at the same time look quite hairy.  Christoph said that having a
  standard userland C-R implementation would be quite useful and IMHO
  it would be helpful in that direction if the implementation is
  modularized enough so that the core functionality and the set of
  workarounds can be easily separated.  Is it already so?

Thanks.

-- 
tejun
