Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab2F0SAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:00:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53380 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab2F0SAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:00:53 -0400
MIME-Version: 1.0
In-Reply-To: <1340801169.16702.9.camel@gandalf.stny.rr.com>
References: <CAJL_eku9byV+Uk-5boR52HLEO0D-++2h_y=PeaaQG_PrCuALhQ@mail.gmail.com>
 <1340060577-9112-1-git-send-email-dhsharp@google.com> <1340293617.27036.177.camel@gandalf.stny.rr.com>
 <CAJL_ekt-iVgh-GG_PoY_eqobgdUGf_L4TH6zmVa4D9oBgohCsA@mail.gmail.com>
 <1340407900.27036.275.camel@gandalf.stny.rr.com> <CAJL_eksV6R2Je+qoBYAtvZ6pSb8d6HdNiBic7AH0TG3u2R0FzQ@mail.gmail.com>
 <CAJL_eksSXfq4RVZ_rHagpgex96Jq=QkpiW93hD7M5xoYscq2jQ@mail.gmail.com> <1340801169.16702.9.camel@gandalf.stny.rr.com>
From: David Sharp <dhsharp@google.com>
Date: Wed, 27 Jun 2012 11:00:30 -0700
Message-ID: <CAJL_eks3n3J3nkfYJLx=hbQ36utjodByr=z-q=s-uwWpvWmDXg@mail.gmail.com>
Subject: Re: [PATCH] ring-buffer: fix uninitialized read_stamp
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 5:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2012-06-26 at 17:35 -0700, David Sharp wrote:
> > On Fri, Jun 22, 2012 at 6:27 PM, David Sharp <dhsharp@google.com> wrote:
> > > On Fri, Jun 22, 2012 at 4:31 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > >>
> > >> Now I think you may understand my patch.
> > >
> > > Yeah, mostly. At least enough that I think it's worth testing. But Monday.
> >
> > I got around to testing your patch today, and it fixes the issue. No
> > bad-looking timestamps in 40 runs, whereas could reproduce within 3
> > runs before. Do you want me to send you a fresh patch, or just use the
> > one you have?
>
> I rather use this one for two reasons.

I just meant, do you want me to send you a version of your patch with
my description (I'll update it, obviously), or do it yourself.

>
> 1) it limits the places where read_stamp is updated. And I rather not
> add an update because "it fixes an anomaly".
>
> 2) I think it is wrong to force the writer on the reader page when no
> write has been made. There's some side effects that this causes. One is
> that if you do a read with no write, and then do nothing, it forces the
> writer on that page. Now if a lot of writes happen (function tracing),
> the writes that were on the reader page are never overwritten when the
> buffer is full. Then you get a page of very old data, followed by a
> buffer full of new data.

I have always disliked that page of very old data, so I'm really happy
that this will get rid of it. As I recall, you once claimed this was a
"feature". :)
