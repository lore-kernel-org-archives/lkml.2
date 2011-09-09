Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab1IIMAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 08:00:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47823 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758764Ab1IIMAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 08:00:24 -0400
Subject: Re: [PATCHv3] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: david.wagner@free-electrons.com
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Date: Fri, 09 Sep 2011 15:02:45 +0300
In-Reply-To: <1315569206.7905.41.camel@sauron>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
	 <1315280704.19067.14.camel@sauron> <1315282208.19067.24.camel@sauron>
	 <201109081726.00769.arnd@arndb.de> <1315569206.7905.41.camel@sauron>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1315569770.7905.45.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 14:53 +0300, Artem Bityutskiy wrote:
> David, I am really busy and now, I suggest you to think about this. I'd
> so far stick to the own ubiblk cdev approach, and would
> analyse/prototype the approach of using UBI cdev for this. I provided
> some concerns above. Also, think about race conditions like:
> 
> 1. Someone

Sorry, I wonted to talk about situations when someone opens an ubiblk
device while the underlying UBI volume is being removed, but then though
this is trivial and forgot to erase the last sentence.

Anyway, I suggest the following algorithm:

1. Stick with the own cdev approach - the driver becomes very simple
   in this case - we review it.
2. Once it is ready, or in parallel, you can play with the second
   approach and if you find it solid/nice, you can then provide a
   new version and/or the delta.

The idea is that on step 1 we review/deal with other things, without
being blocked by the ioctl stuff.

-- 
Best Regards,
Artem Bityutskiy

