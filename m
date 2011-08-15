Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab1HOTwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:52:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54663 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab1HOTwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:52:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=N0y6XluToV5R3Gc2fBZ6HcxxvgLAmqKP3l0CqD4zayaN8d4x+SW9KKqza0hJOfVws
	NLDkE0/T830DDY207D/Rg==
MIME-Version: 1.0
In-Reply-To: <20110815191745.GA7178@legolas.emea.dhcp.ti.com>
References: <1313434172-18319-1-git-send-email-dianders@chromium.org>
	<20110815191745.GA7178@legolas.emea.dhcp.ti.com>
Date: Mon, 15 Aug 2011 12:52:36 -0700
X-Google-Sender-Auth: L6cFP7KRoP2lHoS9Eo70xAskXFU
Message-ID: <CAD=FV=Xd67iw=GXV9i4O5LKnJd20=BkYyfVuxPgxQ5GZRJEy4A@mail.gmail.com>
Subject: Re: [PATCH] i2c: tegra: Check for overflow errors with BUG_ON.
From: Doug Anderson <dianders@chromium.org>
To: balbi@ti.com
Cc: Ben Dooks <ben-linux@fluff.org>, Stephen Warren <swarren@nvidia.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>, Jean Delvare <khali@linux-fr.org>,
        Rakesh Iyer <riyer@nvidia.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

On Mon, Aug 15, 2011 at 12:17 PM, Felipe Balbi <balbi@ti.com> wrote:
> so due to a FIFO overflow you lock up the whole system ? Can't you e.g.
> reset the controller and reconfigure it rather than locking up the
> system ?

Certainly we could try to be more proactive and reset / retry / return
the error to the client.  However, since the only expected situation
where this BUG_ON should hit is due to a bug in this driver itself
(AKA: i2c clients shouldn't be able to do anything to cause the BUG_ON
to hit), that seems like a lot of added complexity.

Also: if there is an arbitrary software bug that causing an overflow
condition to occur, I'm not sure how stable the system will be.
Specifically, the i2c controller is used (among other things) to talk
to the PMU and adjust voltages in the system.  If we just sent it a
random command, I'd rather report the bug right away so we don't get
hard to find/reproduce failures in other parts of the system.

What do others think?

-Doug
