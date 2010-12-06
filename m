Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab0LFTwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 14:52:14 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59976 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab0LFTwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 14:52:12 -0500
MIME-Version: 1.0
In-Reply-To: <4CFD2E15.50105@canonical.com>
References: <1291224069-11770-1-git-send-email-rydberg@euromail.se>
	<4CFD2E15.50105@canonical.com>
Date: Mon, 6 Dec 2010 13:52:12 -0600
Message-ID: <AANLkTingU7pUSwt6myUYzDhMVWg7PqfFpftw_hjsE4iK@mail.gmail.com>
Subject: Re: [PATCH 3/3] input: mt: Move tracking and pointer emulation to
 input-mt (rev2)
From: Chris Bagwell <chris@cnpbagwell.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pingc@wacom.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 12:40 PM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> On 12/01/2010 09:21 AM, Henrik Rydberg wrote:
>> The drivers using the type B protocol all report tracking information
>> the same way. The contact id is semantically equivalent to
>> ABS_MT_SLOT, and the handling of ABS_MT_TRACKING_ID only complicates
>> the driver. The situation can be improved upon by providing a common
>> pointer emulation code, thereby removing the need for the tracking id
>> in the driver.  This patch moves all tracking event handling over to
>> the input core, simplifying both the existing drivers and the ones
>> currently in preparation.
>
> When two or more fingers are down, one of the fingers controls
> ABS_{X,Y}. I think the aim is to emulate current behavior for
> synaptics-style touchpads, which average the position in firmware. Thus,
> we should be averaging the touch positions to generate the ABS_{X,Y} values.
>

At least for modern synaptics hardware, it does track to first touch
like this patch does.

It is maybe a weighted average were its 90% first finger and 10%
second finger.  Just moving second finger gives slight movement.

I can't really speak for other touchpad behavior.

Chris
