Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1E3VEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 17:04:36 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53905 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1E3VEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 17:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ln9UXz2u0LSILHfXBX3yF4bZ+YuEJEFvycsBjycQ5y1l/TGbWYYK/VcJqh7T4d7f7O
         FgKM1RM/VYoXjieuByqJt+DEEQ26+j2I3Ji4AZcYhUmlxcDlBIvpR5W/XtRleU7LM0eJ
         H6ZGftSIa9vIhokk05xmsGQs87jUUU7K9MK0Q=
MIME-Version: 1.0
In-Reply-To: <4DDFD2F7.1050305@gmail.com>
References: <4DDECFC8.7090903@gmail.com>
	<20110527095036.GK21386@elte.hu>
	<4DDFBD83.3020105@gmail.com>
	<4DDFD2F7.1050305@gmail.com>
Date: Mon, 30 May 2011 17:04:33 -0400
Message-ID: <BANLkTi=uKSKNJCJquKm44ofMwcTmfwAPyw@mail.gmail.com>
Subject: Re: perf: h/w counters not counted and no error/info reported to user
From: Ashwin Chaugule <ashbertslists@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Fri, May 27, 2011 at 12:36 PM, David Ahern <dsahern@gmail.com> wrote:
>
> Ok, I got it now. On some occasions for simple programs -- like sleep 1
> -- the counter reads show:
>
> cycles: 0 1066485 0
>
> While the counter value is non-0, the time enabled and running values
> are 0 and those latter two are used by stat to say "not-counted".

I've seen time-enabled = 0 too, but I suspected that's because on my
kernel the sched_clock implementation was missing. (defaults to a
jiffies based timer)
I saw your patch for initializing the fd's to -1's, but I'm unable to
see how that makes the value of time-enabled non zero ?

Cheers,
Ashwin
