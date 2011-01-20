Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab1ATWiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 17:38:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52486 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab1ATWiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:38:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=FbGgEIkTWftmCkCrpewkwx9uE59wQFSluFXMVQNIlszlrFLHiEwjADXrrBqq60asUC
         UzN+hO/j/u4rAAdve0MVDu32XEeuVt6YBFXhaoukPsh2e4GiZYKHLU6wZxqd1HCKzjYY
         CmDiA/dEMgq9bg3MHKETb48IejgIVyv7aUYaU=
MIME-Version: 1.0
In-Reply-To: <AANLkTikLY1B3=C2TjAbYKVHbub-aPeG2heaUBWRUAg=R@mail.gmail.com>
References: <20110119.180418.216749267.davem@davemloft.net>
	<AANLkTin32jUnBtHF-EAkSMnFQM6cTbn-G3NZQJ3xjTWU@mail.gmail.com>
	<1295559646.2613.35.camel@edumazet-laptop>
	<AANLkTikLY1B3=C2TjAbYKVHbub-aPeG2heaUBWRUAg=R@mail.gmail.com>
Date: Thu, 20 Jan 2011 17:38:05 -0500
X-Google-Sender-Auth: dhAaGXNswOEvoZaEv65E42_ZRvI
Message-ID: <AANLkTin6GM5W0nmWgD1a-2FK=CvHk=P3o6CYe-sFe6c=@mail.gmail.com>
Subject: Re: [GIT] Networking
From: Colin Walters <walters@verbum.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 5:21 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jan 20, 2011 at 1:40 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> Then here ask for fd=3 both POLLIN and POLLOUT :
>> kernel answers : OK for POLLOUT (not POLLIN), so previous poll() call
>> was OK to be blocked after all...
>>
>> So I'm wondering if it could be a userland bug, that triggers with
>> recent kernel changes.
>
> As far as I can tell, that program isn't multi-threaded

It is actually; see src/gs-auth-pam.c; there is some pretty scary code
there; basically all of PAM is put in a thread to avoid blocking the
mainloop.  Whether the code is actually buggy I can't say immediately;
it's certainly possible.
