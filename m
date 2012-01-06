Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab2AFSzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 13:55:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39116 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab2AFSzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 13:55:22 -0500
Message-ID: <4F0743EE.6080302@canonical.com>
Date: Fri, 06 Jan 2012 10:56:46 -0800
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: evdev - Add EVIOC mechanism to extract the
 MT slot state
References: <1325863019-2242-1-git-send-email-rydberg@euromail.se> <CAN+gG=FUEH851Um4Lco0avqdE2Eup3Jo79Ti4T7XhxT=PO6WeQ@mail.gmail.com> <20120106181845.GA22653@core.coreip.homeip.net>
In-Reply-To: <20120106181845.GA22653@core.coreip.homeip.net>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2012 10:18 AM, Dmitry Torokhov wrote:
> Hi Benjamin,
> 
> On Fri, Jan 06, 2012 at 07:00:22PM +0100, Benjamin Tissoires wrote:
>> Hi guys,
>> I read somewhere in the code of Android a comment in which they
>> complain about not being able to retrieve the slots states. So they
>> assume they are all at 0.
>> So this mechanism is good to have.
>> However, back in January 2011, Dmitry raised the problem that this
>> code was not thread safe.What happens if 2 applications ask for
>> different slots values (let say X.org and utouch-frame)?
> 
> 2 different processes should be fine; the problem would be if 2 threads
> of the same process share the same file descriptor. So far the rest of
> evdev copes just fine with multiple threads using the same fd (all
> operations are atomic in this regard), setting ABS_MT_SLOT before
> fetching the state break this property.

How is this any different than two threads trying to set a different
property, like the fuzz factor of an axis? This seems like something
that should be guarded by a lock in userspace, essentially.

-- Chase
