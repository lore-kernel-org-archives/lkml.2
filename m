Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946877Ab2ERXLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:11:14 -0400
Received: from mga10.intel.com ([192.55.52.92]:2953 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946766Ab2ERXLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:11:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120518222507.GA7188@sergelap>
References: <1337284200-1838-1-git-send-email-auke-jan.h.kok@intel.com>
	<20120518222507.GA7188@sergelap>
Date: Fri, 18 May 2012 16:11:07 -0700
Message-ID: <CABsxX9+Tt5Ey0qpUWqS7beVOCiBzWtSDGU+Bd2KiN=07Bkm3SA@mail.gmail.com>
Subject: Re: [PATCH] Trace event for capable().
From: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 3:25 PM, Serge Hallyn
<serge.hallyn@canonical.com> wrote:
> Quoting Auke Kok (auke-jan.h.kok@intel.com):
>> Add a simple trace event for capable().
>>
>> There's been a lot of discussion around capable(), and there
>> are plenty of tools to help reduce capabilities' usage from
>> userspace. A major gap however is that it's almost impossible
>> to see or verify which bits are requested from either userspace
>> or in the kernel.
>>
>> This patch adds a minimal tracer that will print out which
>> CAPs are requested and whether the request was granted.
>>
>> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
>> Cc: linux-security-module@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: Serge Hallyn <serge.hallyn@canonical.com>
>
> Hi,
>
> is there any measurable performance impact by this patch?  (Have you
> measured it?)

I actually did a full OS boot test and didn't see a noticeable
difference - basically
 booted with init=/bin/bash, mount debugfs, start the tracer and then
exec /sbin/init...
It's anecdotal, but, given the use of this tracer should be more than
acceptable.

Of course, there is a small (nop - ~1 cycle) penalty to the tracepoint
even if tracing
is disabled, but the codepath should never be in any form of hotpath no matter
what, since any call to capable() will end up in LSM checks and audit
checks anyway.

> I'm not familiar enough with the tracing stuff, but if the tracing is
> done so there's no impact when not tracing, then I have no problem with
> this.  It could be quite useful as you say.
>
> Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>

thanks, - I might resend a new patch if I can add the namespace info
as per the other comment.

Auke
