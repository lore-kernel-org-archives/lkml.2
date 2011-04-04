Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab1DDVxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:53:02 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43026 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1DDVxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:53:00 -0400
MIME-Version: 1.0
In-Reply-To: <20110404213338.GB984@core.coreip.homeip.net>
References: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
 <1301727259-5185-3-git-send-email-jeffbrown@android.com> <20110404213338.GB984@core.coreip.homeip.net>
From: Jeffrey Brown <jeffbrown@android.com>
Date: Mon, 4 Apr 2011 14:52:19 -0700
Message-ID: <BANLkTineFm2WvtHi6pL6f3UOhPcpiRdKQA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] input: evdev: Indicate buffer overrun with SYN_DROPPED.
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: rydberg@euromail.se, djkurtz@google.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Mon, Apr 4, 2011 at 2:33 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Fri, Apr 01, 2011 at 11:54:18PM -0700, Jeff Brown wrote:
>> +      * When the client buffer is full, drain the buffer and enqueue a
>> +      * SYN_DROPPED event to let the client know that events were dropped
>> +      * and the last packet was incomplete.  We then consume all remaining
>> +      * events from the dropped packet until the next packet begins.
>
> I do not think we (kernel) should be doing this. Clients should take
> care and not allow overruns but if they happen the pain should be on the
> client to restore the context. It has to query the device to get its
> current state and it can drop the events till next sync as well.

That's fine.  We should document SYN_DROPPED and mention that the
client should wait until after the next SYN_REPORT to get back in
sync.

> Therefore I intend to apply the patch in the form below.

Looks good to me.  It's more like my original patch.

Jeff.
