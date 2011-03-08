Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1CHACf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 19:02:35 -0500
Received: from smtp-out.google.com ([74.125.121.67]:8599 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab1CHACe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 19:02:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CLYtko/emRxCxZuZwNDzNkaDI9HZHhXEd73wLLUAWyX97uZ3yijjkAEy436edwqF6o
         H0kgVbb90BZvHJkiXyCw==
MIME-Version: 1.0
In-Reply-To: <20110307150735.3d6515f2@nehalam>
References: <20110307021450.GC31188@google.com>
	<20110307150735.3d6515f2@nehalam>
Date: Mon, 7 Mar 2011 16:02:30 -0800
Message-ID: <AANLkTi=+XXypyyOkGmAnuX+3Hsw50yOrqo9j6bX6LCRH@mail.gmail.com>
Subject: Re: [PATCH] drivers/net: fix build warnings with CONFIG_PM_SLEEP disabled
From: Michel Lespinasse <walken@google.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 3:07 PM, Stephen Hemminger
<shemminger@linux-foundation.org> wrote:
> On Sun, 6 Mar 2011 18:14:50 -0800
> Michel Lespinasse <walken@google.com> wrote:
>
>> This fixes a couple of build warnings when CONFIG_PM is enabled but
>> CONFIG_PM_SLEEP is disabled. Applies on top of v2.6.38-rc7 - I know it's
>> late, but it would be great if v2.6.38 could compile without warnings!
>>
>> Signed-off-by: Michel Lespinasse <walken@google.com>
>
> This is standard throughout all the network drivers.
> Why just fix 2?

I only looked at the build warnings we get with our local config.
Some drivers do get this right, such as tg3 for example.

Having a quick look at other SIMPLE_DEV_PM_OPS users, it seems at
least drivers/net/skge.c does have the same issue though.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
