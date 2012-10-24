Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933926Ab2JXAwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 20:52:19 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:36582 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933407Ab2JXAwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 20:52:17 -0400
MIME-Version: 1.0
In-Reply-To: <1351030575.2459.21.camel@palomino.walls.org>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
	<1351022246-8201-17-git-send-email-elezegarcia@gmail.com>
	<1351030575.2459.21.camel@palomino.walls.org>
Date: Tue, 23 Oct 2012 21:52:16 -0300
Message-ID: <CALF0-+WUBp4_50STBT2C2X_CRM3bjWw1C49fHu4wynXLZHgvHg@mail.gmail.com>
Subject: Re: [PATCH 17/23] cx23885: Replace memcpy with struct assignment
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>, stoth@kernellabs.com,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCed Steven Toth and Devin Heitmueller)

On Tue, Oct 23, 2012 at 7:16 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Tue, 2012-10-23 at 16:57 -0300, Ezequiel Garcia wrote:
>> This kind of memcpy() is error-prone. Its replacement with a struct
>> assignment is prefered because it's type-safe and much easier to read.
>>
>> Found by coccinelle. Hand patched and reviewed.
>> Tested by compilation only.
>>
>> A simplified version of the semantic match that finds this problem is as
>> follows: (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> identifier struct_name;
>> struct struct_name to;
>> struct struct_name from;
>> expression E;
>> @@
>> -memcpy(&(to), &(from), E);
>> +to = from;
>> // </smpl>
>>
>> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>
> This patch looks OK to me.  You forgot to CC: Steven Toth and/or Devin
> Heitmueller (I can't remember who did the VBI work.)

Done, thank you.

    Ezequiel
