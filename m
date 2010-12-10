Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab0LJTA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 14:00:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59496 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab0LJTA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 14:00:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=j6bX5GcMGztjrLtqZ9uIdjOdU2afD6qLT0YPNW7pgXLzypeTCkFEs/N3j0MLbZ1atr
         sGOPyWxLPHV/j0WYpFELwcBduX5qPp7kDhnCimHMutSqwYKmfy3eV5FsfFtVriPPuHPt
         2/WjQjGCjGeb2AaRYIhPWUWu+XuRAxTSLKUuU=
MIME-Version: 1.0
In-Reply-To: <4D026DB1.8070100@euromail.se>
References: <1291929732-5989-1-git-send-email-rydberg@euromail.se>
	<AANLkTi=mqMY_VG=0RdN5O0fDh6wpTRb5Z59L6440hvX6@mail.gmail.com>
	<4D026DB1.8070100@euromail.se>
Date: Fri, 10 Dec 2010 11:00:25 -0800
Message-ID: <AANLkTinctPSxGt36HCdyoWYH7TBznzY0CejLP3uALkV3@mail.gmail.com>
Subject: Re: [PATCH] input: mt: Interface and MT_TOOL documentation updates
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 10:13 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>
>> Can we make MT_TOOL_ENVELOPE cover a bit more cases by:
>>
>> 1. Removing ", and is only used for legacy hardware";
>> 2. Adding "Or the number of contacts inside the bounding rectangle is
>> reported if hardware provides the number but not the real contact
>> positions" to the end of the paragraph.
>
> You might disagree, but "old" is still somewhat apt in this situation.

It's ok if we say the new type was inspired by legacy hardware. But
saying that it "is only used for legacy hardware" closes the door for
future development. That's not what we are trying to do, right?

> How would you suggest we report the number of fingers?

I guess if we want to make it generic, we could have something like
ABS_MT_NUM_CONTACTS to go with MT_TOOL_ENVELOPE. Clients, such as
synaptics touchpads, that only care about the number of contacts
inside the envelope don't need to process the contact positions even
when they are reported. This also resolve the potential that
BTN_TOOL_QUADTAP is not enough to tell us how many contacts are on the
surface.

Maybe we should also tell the clients whether they are going to get
the contact positions or not.

Ping
