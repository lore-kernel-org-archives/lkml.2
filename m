Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab2GPCfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 22:35:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33071 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab2GPCeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 22:34:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120705191539.GA14454@polaris.bitmath.org>
References: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
 <1340888904-15620-5-git-send-email-djkurtz@chromium.org> <20120705172230.GB31383@core.coreip.homeip.net>
 <20120705191539.GA14454@polaris.bitmath.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Mon, 16 Jul 2012 10:34:14 +0800
X-Google-Sender-Auth: DNP6xo_5YUln1L12uP3YoySDsL0
Message-ID: <CAGS+omCtWiWWeW241mxh_jcYXVfsmBVcKT8VZS_f-war=L+gJQ@mail.gmail.com>
Subject: Re: [PATCH 04/23 v6] Input: atmel_mxt_ts - warn if sysfs could not be created
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 3:15 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Thu, Jul 05, 2012 at 10:22:30AM -0700, Dmitry Torokhov wrote:
>> Hi Daniel, Henrik,
>>
>> On Thu, Jun 28, 2012 at 09:08:05PM +0800, Daniel Kurtz wrote:
>> > If sysfs entry creation fails, the driver is still usable, so don't
>> > just abort probe.  Just warn and continue.
>> >
>>
>> I understand that I am a bit late to the party :) but I do not agree
>> with this change. Failure to create attributes is not sometihng that
>> user could cause (at least not easily) and thus would not be a setup
>> issue but something more severe. I believe we should fail loading the
>> driver so sysfs attribute breakage will be noticed as soon as possible,
>> instead of discovering it much much later in the process.
>>
>> So I think we should revert this one.
>
> Ok, I agree. Applied and pushed.
>
> Daniel, I should probably have asked this before: what was the reason
> for this patch in the first place?
>
> Thanks,
> Henrik

No additional reason beyond what is stated in the commit message -
that the driver is still usable without its sysfs entries, so no need
to abort probe.

I'm fine with reverting back to the fail fast approach, too.

Thanks,
Daniel
