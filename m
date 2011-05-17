Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab1EQXKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 19:10:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33521 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932553Ab1EQXKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 19:10:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Subject: Re: pm loss development
Date: Wed, 18 May 2011 01:10:52 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com> <201105131854.57854.rjw@sisk.pl> <BANLkTi=0T_jmEju+cP8zG8EC0ns-mwKHYw@mail.gmail.com>
In-Reply-To: <BANLkTi=0T_jmEju+cP8zG8EC0ns-mwKHYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105180110.52631.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 14, 2011, Raffaele Recalcati wrote:
> > I read the patches.  My question was about the general idea of who should
> > be responsible of making these decisions.
> 
> The best  should be, I think, to have some guidelines and than the
> possibility to choose the best policy for each situation.

Again, I'd like to know who's supposed to make the choice.

> In my board I needed to shutdown video in capture and demodulator
> circuit, so I have implemented vpfe capture switch off, that does
> stream_off to all its v4l2 subdevices (a pal decoder and a video
> demodulator).
> So I can save 30mA, and it allows to my board to survive longer.
> I need to do some tests and have some data with and without PM loss.

That's fine, but in general we need to take care of a few more things,
like the interactions between the devices we're switching off and user
space (that can be doing just about anything at the moment).

We can't simply switch off devices at will, because that may lead to
breakage too in general.

Thanks,
Rafael
