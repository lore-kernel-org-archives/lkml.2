Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab1HGRUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 13:20:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57162 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1HGRUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 13:20:32 -0400
MIME-Version: 1.0
In-Reply-To: <1312362279.10579.38.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1312362279.10579.38.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Sun, 7 Aug 2011 10:20:30 -0700
Message-ID: <CAF8ieYU2ThME1Q3u6xOp0sVOh-dPep-874TDY-=-q9E3OiSQAg@mail.gmail.com>
Subject: Re: avr32: handle_signal() bug?
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Wed, Aug 3, 2011 at 2:04 AM, Matt Fleming <matt@console-pimps.org> wrote:
> That doesn't look correct to me. Now, if we were unsuccessful in setting
> up a signal frame, say, ret == -EFAULT, do we really want to block the
> signal or any of the signals in the handler mask?

I'm assuming this is a rhetorical question :-)

> Is there some intricacy of the avr32 architecture that I'm missing here?
> It looks to me like this code was copied from the arm implementation
> from years ago before commit a6c61e9dfdd0 ("[ARM] 3168/1: Update ARM
> signal delivery and masking").

I don't think there are any avr32-specific intricacies to consider
here, and ARM was indeed one of the architectures I looked at when
writing the signal handling code, so I probably picked up that bug
from there.

> How about this?

Looks good to me. I'm not sure how to test it though...I can try to
build a kernel, run it on my board and see if it explodes, but I
suspect this bug is a lot more subtle than that.

Havard
