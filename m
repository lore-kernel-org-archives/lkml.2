Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab0LFUAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:00:24 -0500
Received: from adelie.canonical.com ([91.189.90.139]:54172 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab0LFUAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:00:22 -0500
Message-ID: <4CFD40CD.1000304@canonical.com>
Date: Mon, 06 Dec 2010 12:00:13 -0800
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Chris Bagwell <chris@cnpbagwell.com>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pingc@wacom.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] input: mt: Move tracking and pointer emulation to
 input-mt (rev2)
References: <1291224069-11770-1-git-send-email-rydberg@euromail.se>	<4CFD2E15.50105@canonical.com> <AANLkTingU7pUSwt6myUYzDhMVWg7PqfFpftw_hjsE4iK@mail.gmail.com>
In-Reply-To: <AANLkTingU7pUSwt6myUYzDhMVWg7PqfFpftw_hjsE4iK@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 11:52 AM, Chris Bagwell wrote:
> On Mon, Dec 6, 2010 at 12:40 PM, Chase Douglas
> <chase.douglas@canonical.com> wrote:
>> On 12/01/2010 09:21 AM, Henrik Rydberg wrote:
>>> The drivers using the type B protocol all report tracking information
>>> the same way. The contact id is semantically equivalent to
>>> ABS_MT_SLOT, and the handling of ABS_MT_TRACKING_ID only complicates
>>> the driver. The situation can be improved upon by providing a common
>>> pointer emulation code, thereby removing the need for the tracking id
>>> in the driver.  This patch moves all tracking event handling over to
>>> the input core, simplifying both the existing drivers and the ones
>>> currently in preparation.
>>
>> When two or more fingers are down, one of the fingers controls
>> ABS_{X,Y}. I think the aim is to emulate current behavior for
>> synaptics-style touchpads, which average the position in firmware. Thus,
>> we should be averaging the touch positions to generate the ABS_{X,Y} values.
>>
> 
> At least for modern synaptics hardware, it does track to first touch
> like this patch does.
> 
> It is maybe a weighted average were its 90% first finger and 10%
> second finger.  Just moving second finger gives slight movement.

Ok. Does this present any usability issues, or does it seem to work fine
in your opinion? If it works ok in normal use cases then I'm fine with
how this is implemented.

-- Chase
