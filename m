Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab2HHAtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 20:49:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59295 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2HHAtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 20:49:43 -0400
MIME-Version: 1.0
Date: Tue, 7 Aug 2012 17:49:41 -0700
Message-ID: <CAB9O=CPoMdkbnCOTreUuNZ+yHa_+8L1A4VXk6A1ODtgxoGjz7Q@mail.gmail.com>
Subject: changing clock source frequency input for ARM kernel
From: John Linn <johnhlinn@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: damm@opensource.se
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are working on CPU frequency scaling and our clock source is
dependent on our CPU frequency. When we change the CPU frequency we'd
like to update the clock source so the time keeping is all correct.

It's not clear to use how to make this correcly. The ST mobile stuff
is the only example of calling clocksource_updatefreq() that we see,
but since it's in the enable function it's not clear that this will
help us.

We have another timer in the block that we can use to allow us to ping
pong when updating the frequency if needed, but it's still based on
the same clock which is dependent on the CPU frequency.  It seems not
wise to disable the clock source if there's only one then re-enable
it.

Thanks for any help,
John
