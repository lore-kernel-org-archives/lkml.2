Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab2FRSgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 14:36:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61573 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2FRSgu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 14:36:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120616233526.7f830890@pyramind.ukuu.org.uk>
References: <1339884266-9201-1-git-send-email-dh.herrmann@googlemail.com>
	<1339884266-9201-5-git-send-email-dh.herrmann@googlemail.com>
	<20120616233526.7f830890@pyramind.ukuu.org.uk>
Date: Mon, 18 Jun 2012 20:36:48 +0200
Message-ID: <CANq1E4S=s3fE9Yf4_sqKrJ_FP7OS7qHC8hmD5autBSJLmF7Z+Q@mail.gmail.com>
Subject: Re: [PATCH 04/10] fblog: implement fblog_redraw()
From: David Herrmann <dh.herrmann@googlemail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-serial@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan

On Sun, Jun 17, 2012 at 12:35 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Sun, 17 Jun 2012 00:04:20 +0200
> David Herrmann <dh.herrmann@googlemail.com> wrote:
>
>> This mostly copies the functionality from drivers/video/console/bitblit.c
>> so we can draw the console content on all available framebuffers.
>>
>> All speed optimizations have been removed for simplicity. The original
>> code depends heavily on CONFIG_VT so we cannot share the codebase here.
>
> No. That means we've got two sets of code to maintain not one. Fix the
> dependancy.
>
> Pull the relevant subset of struct vc_data into another struct
> Make struct vc_data be
>
> struct vc_data {
>        struct vc_whatever
>        rest
> }

It's a bit more complex as we cannot call scr_read() either. Hence, I
need to assemble the array of printed characters before calling the
redraw functions. But that should be feasible, too. I just need to
figure out how to avoid heavy allocations during redraw to avoid
slowdowns.

If there are no objections I will send these patches as a separate
patchset as we can apply it without fblog.

> Alan

Thanks for reviewing
David
