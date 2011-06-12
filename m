Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1FLWBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 18:01:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:44991 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab1FLWBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 18:01:37 -0400
Date: Mon, 13 Jun 2011 00:01:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid-multitouch: fix broken eGalax
In-Reply-To: <20110612211500.GA19269@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1106122359300.22872@pobox.suse.cz>
References: <1307859728-3446-1-git-send-email-benjamin.tissoires@enac.fr> <20110612152915.GA18794@polaris.bitmath.org> <BANLkTikRPnNNVp=78BxvYZzp5A2HbBYEUg@mail.gmail.com> <20110612211500.GA19269@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jun 2011, Benjamin Tissoires wrote:

> Since the inclusion of eGalax devices in 2.6.39, I've got some
> bug reports for 480d and other devices.
> The problem lies in the reports descriptors: eGalax supports both
> pen and fingers, and so the reports descriptors contained both.
> But hid-multitouch relies on them to detect the last item in each
> field to send the multitouch events. In 480d, the last item is not
> Y as it should but Pressure. That means that the fields are not
> aligned and X,Y are at 0,0 (the other touch coordinates of the report).
> 
> With this patch, the detection is made only when the field ContactID
> has been detected inside the collection.
> 
> There is still a problem with the detections of the range as stylus
> and fingers may not have the same min/max, but it's a start.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---
> 
> Hi guys,
> 
> I'd love to see this patch into stable too. The point is that it does
> not applies out of the box. Should I send it again to stable@kernel.org
> once the reviews has been made?

The best thing is to wait for the patch to appear in Linus' tree (which is 
a prerequisity for -stable inclusion anyway), and then send a backported 
version, with upstream reference commit, to stable@kernel.org.

On Sun, 12 Jun 2011, Henrik Rydberg wrote:

> Thanks for the clarification.
> 
>     Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks, I have now applied it.

I am waiting with pushing my upstream-fixes branch to Linus before the 
magicmouse issue has been sorted out (waiting for tester Ack). If this 
doesn't happen in a day or two, I will be pushing it anyway.

Thanks,

-- 
Jiri Kosina
SUSE Labs
