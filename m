Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab2I1Ot4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:49:56 -0400
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:65122 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960Ab2I1Otz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:49:55 -0400
Message-ID: <5065B909.1060907@cs.tu-berlin.de>
Date: Fri, 28 Sep 2012 16:49:45 +0200
From: =?UTF-8?B?IkphbiBILiBTY2jDtm5oZXJyIg==?= <schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120919 Thunderbird/10.0.7
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: drop ambiguous LOG_CONT flag
References: <5064790E.4000207@cs.tu-berlin.de> <1348820728-13796-1-git-send-email-schnhrr@cs.tu-berlin.de> <CAPXgP11SN7cx7NW0Jv46g+KAvFPo61Ptczochzy4Ub83bjHn1Q@mail.gmail.com>
In-Reply-To: <CAPXgP11SN7cx7NW0Jv46g+KAvFPo61Ptczochzy4Ub83bjHn1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.09.2012 16:34, schrieb Kay Sievers:
> On Fri, Sep 28, 2012 at 10:25 AM, Jan H. Schönherr
> That fails the racing task test, and a cont user that was nicely
> merged before is now all in separate records.

I guess, I need to extend my test cases. Do you have something
ready that I could use?

> It seems, unconditionally using the cont buffer like in your patch,
> for all incoming messages just makes the entire cont merge buffer
> dance useless when it comes to races.

I see. :(

> The current behaviour has the advantage, that non-cont users will not
> race against a cont user (which is like 99.x% of the races I expect).
> The cont buffer is currently only used when we expect a cont user,
> non-cont users happening in the middle of a cont-print will not flush
> the and disturb the cont buffer.

That should be fixable by using a second set of flags, owner, and so on
within vprintk... I still think, that getting rid of of remotely tracking
the flags is worth something.

(Ideally, we should also be able to correctly reassemble multiple
simultaneous cont users. But that it still a bit out of scope I think.)

Given that I'm able to fix the racing case, would you be in favor of
this approach, or should we stick to the earlier version?

Regards
Jan
