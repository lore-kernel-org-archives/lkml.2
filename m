Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1EFCjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 22:39:00 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49948 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab1EFCi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 22:38:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=dfawQO9peht+mZ72kCuSFYTmXzK0f9387iyBE5W9xEcuwZUouukqh4hor6mzdX6RAB
         ZFPgKdCK2CG2cS9vji+2eNs9ZE7cC+w5aGD96n/AA1gL5/5VYdcHO/17cV65Vnwv1LtQ
         /VD21eYNt1eSqbF7VdnRNyyIi/BV9xEE/EKgA=
MIME-Version: 1.0
In-Reply-To: <20110420105631.70695dfa@lxorguk.ukuu.org.uk>
References: <BANLkTi=8U3=E0=j8MJ-r70O_aO8Pxvv9Nw@mail.gmail.com>
	<BANLkTi=F8u7oZM+=W+5vzmvf1b0YiN0fQg@mail.gmail.com>
	<20110420080535.3edd11ac@pluto.restena.lu>
	<20110420105631.70695dfa@lxorguk.ukuu.org.uk>
Date: Fri, 6 May 2011 10:38:58 +0800
Message-ID: <BANLkTikF5YL8tJ_f5510yy1Ywm69rOUK2A@mail.gmail.com>
Subject: Re: [2.6.39-rc2, framebuffer] use after free oops
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 April 2011 17:56, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 20 Apr 2011 08:05:35 +0200
> Bruno Prémont <bonbons@linux-vserver.org> wrote:
>
>> On Wed, 20 Apr 2011 13:50:10 Daniel J Blueman <daniel.blueman@gmail.com> wrote:
>> > Any ideas on how best to address this issue [0], since it causes
>> > silent corruption, or at best crashes?
>>
>> There is probably no easy short-term fix to this...
>
> The short term fix would be to deliberately leak the buffer. That should
> go into 2.6.39-rc right now with a comment explaining the situation.
> Otherwise who knows what corruption may occur to user data if unlucky.
>
> The other 'cheat' might be to tweak the API so the removal API isn't a
> 'destroy' interface but a 'shut down' and has a matching 'restart' one
> for when the intelfb unloads at which point vga16fb can carry on with the
> original fb_info 8)

It looks like Andy Whitcroft addressed this issue some time ago, but
forgot to send the fix upstream:

http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-natty.git;a=patch;h=c5a742b5f78e161d6a13853a7e3e6e1dfa429e69;hp=26a1443f67eea17d4b78ef75df701782cc8bf35b

Let's hope it can hit -rc7 since it's been in Ubuntu's kernel tree for
considerable time, and fixes a silent corrupter:

http://groups.google.com/group/linux.kernel/browse_thread/thread/fc9083f6f380ed5b/f801112b840785cb?show_docid=f801112b840785cb

Thanks,
  Daniel
-- 
Daniel J Blueman
