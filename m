Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030493Ab2AFSSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 13:18:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38460 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758961Ab2AFSSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 13:18:53 -0500
Date: Fri, 6 Jan 2012 10:18:45 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chase Douglas <chase.douglas@canonical.com>
Subject: Re: [PATCH v2] Input: evdev - Add EVIOC mechanism to extract the MT
 slot state
Message-ID: <20120106181845.GA22653@core.coreip.homeip.net>
References: <1325863019-2242-1-git-send-email-rydberg@euromail.se>
 <CAN+gG=FUEH851Um4Lco0avqdE2Eup3Jo79Ti4T7XhxT=PO6WeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=FUEH851Um4Lco0avqdE2Eup3Jo79Ti4T7XhxT=PO6WeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Fri, Jan 06, 2012 at 07:00:22PM +0100, Benjamin Tissoires wrote:
> Hi guys,
> I read somewhere in the code of Android a comment in which they
> complain about not being able to retrieve the slots states. So they
> assume they are all at 0.
> So this mechanism is good to have.
> However, back in January 2011, Dmitry raised the problem that this
> code was not thread safe.What happens if 2 applications ask for
> different slots values (let say X.org and utouch-frame)?

2 different processes should be fine; the problem would be if 2 threads
of the same process share the same file descriptor. So far the rest of
evdev copes just fine with multiple threads using the same fd (all
operations are atomic in this regard), setting ABS_MT_SLOT before
fetching the state break this property.

Thanks.

-- 
Dmitry
