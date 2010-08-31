Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab0HaQeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 12:34:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54676 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab0HaQeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 12:34:15 -0400
MIME-Version: 1.0
In-Reply-To: <20100831161644.GA14505@albatros>
References: <1283075566-27441-1-git-send-email-julia@diku.dk>
 <1283075566-27441-2-git-send-email-julia@diku.dk> <4C7D247F.4060500@bfs.de>
 <Pine.LNX.4.64.1008311807470.2668@ask.diku.dk> <20100831161644.GA14505@albatros>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 31 Aug 2010 10:33:52 -0600
X-Google-Sender-Auth: usUhKBURHofo7wX38cm_mxJ1-jQ
Message-ID: <AANLkTi=3b0NY5pFepv-TmjFDmPUBK9Ew16HyTn-+YguX@mail.gmail.com>
Subject: Re: [PATCH 1/7] drivers/macintosh/via-pmu-led.c: Add of_node_put to
 avoid memory leak
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: Julia Lawall <julia@diku.dk>, walter harms <wharms@bfs.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kernel-janitors@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 10:16 AM, Vasiliy Kulikov <segooon@gmail.com> wrote:
> On Tue, Aug 31, 2010 at 18:08 +0200, Julia Lawall wrote:
>> On Tue, 31 Aug 2010, walter harms wrote:
>> > >   if (strncmp(model, "PowerBook", strlen("PowerBook")) != 0 &&
>> > >       strncmp(model, "iBook", strlen("iBook")) != 0 &&
>> > >       strcmp(model, "PowerMac7,2") != 0 &&
>> > >
>> >
>> > is there any rule that says when to use strncmp ? it seems perfecly valid to use strcpy here
>> > (what is done in the last cmp).
>>
>> Perhaps there are some characters after eg PowerBook that one doesn't want
>> to compare with?
>
> It seems to me that model has no '\0' in the end. If model is got from
> the hardware then we should double check it - maybe harware is buggy.
> Otherwise we'll overflow model.

Model does have \0 at the end.  This code is using strncmp to
purposefully ignore the model suffix.

> But why strcmp(model, "PowerMac7,2")? IMO it should be replaced
> with strncmp().

We use strcmp when parsing the device tree because the the length of
the model property string is unknown and in most cases we *must* match
the exact entire string, such as with this PowerMac7,2 example.  Using
strncmp would also happen to match with something like
"PowerMac7,2345" which is not the desired behaviour.

g.
