Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab1EDInW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:43:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43331 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab1EDInV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:43:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZMUHmymmR5i4Rmda49/HMJawGX/Yxt0ZwDkQPpXC+58pmMztu4lWM6fF6IS4foa6zz
         YObJ6hGOpDESv+67q8TA8Jok4bFj375CcktB5z+lyJKWU5GzFuhiK0crts56E9IEHpzy
         TkReNO3ePyaEC2/3vv058Lxh4r6r/x1qmwuvg=
MIME-Version: 1.0
In-Reply-To: <201104292211.03702.rjw@sisk.pl>
References: <201104290154.12966.rjw@sisk.pl>
	<201104290154.56145.rjw@sisk.pl>
	<BANLkTinsKELoZAZgu0wzT_fQc1kWnd-EVg@mail.gmail.com>
	<201104292211.03702.rjw@sisk.pl>
Date: Wed, 4 May 2011 17:43:19 +0900
Message-ID: <BANLkTimbUQ9-U9yPkCspf=dL0JfyXqbSng@mail.gmail.com>
Subject: Re: [linux-pm] [RFC][PATCH 1/2] PM / Runtime: Support for generic I/O
 power domains
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-sh@vger.kernel.org, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 5:11 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Well, not really.  There are a few things to consider.
>
> First, in general, there may be devices that have a real parent and belong
> to a power domain at the same time, so we can't "steal" the parent
> pointers from them.

Ah. right we only have one parent per device. Ok, setting a power
domain as a device's parent is not going to work for some devices.


However, I have some other questions.

1. pm_genpd_runtime_suspend and pm_genpd_runtime_resume are opened to
outside (not static and "extern"ed). Are devices supposed to call
pm_genpd_runtime_* directly? Shouldn't they be hidden so that devices
are forced to turn on/off power domains with runtime_pm framework
only? Is there any reason to expose them?

2.  If we can assure that related clocks are not turned on when a
power domain is shutting down, it'd be nice.
I guess it would be sufficient to let it "WARN" at
gov->power_down_ok(). Is it the intention of governor?


Thank you! I also think this is going to help us a lot, too :)

- MyungJoo
-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
