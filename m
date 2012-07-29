Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2G2CVY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 22:21:24 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59379 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2G2CVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 22:21:23 -0400
Message-ID: <50149E15.9070002@kernel.org>
Date: Sat, 28 Jul 2012 22:21:09 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/4] x86 idle APM: delete apm_cpu_idle()
References: <1343428975-3897-1-git-send-email-lenb@kernel.org> <f8c928c1d43f5c4d1342bd05ca29c8ea788726b8.1343428708.git.len.brown@intel.com> <20120728111148.39ff7230@ultron>
In-Reply-To: <20120728111148.39ff7230@ultron>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2012 06:11 AM, Alan Cox wrote:
> On Fri, 27 Jul 2012 18:42:53 -0400
> Len Brown <lenb@kernel.org> wrote:
> 
>> From: Len Brown <len.brown@intel.com>
>>
>> The APM idle feature to call into the BIOS
>> is known to break some machines, and it has dubious benefit
>> on the (decades old) machines it doesn't break.
> 
> You mean "doesn't fit my current plan" I think. I see almost no bugzilla
> APM reports. It's been solid for years.


Hm, I thought it was actually you that mentioned that this particular
feature of APM caused some systems to fail...

Unfortunately quiet bugzilla doesn't tell us the difference between
"solid as a rock and used by millions of users every day"
and "nobody anywhere running new software on this old hardware".

> It makes a big difference on older systems as it drops the clock. If we
> are going to drop this we should probaly also drop APM support entirely
> and 386/486 support.

Do you have an APM system that boots a 2012 kernel?
Are you willing to test new kernels on it?

> If not IMHO it should stay. Various embedded platforms are still using
> ancient hardware setups.
> 
> This is a small stable piece of code that has required no maintainance in
> years
> 
> Furthermore we have a feature removal process. Mark it down to be removed
> in July 2013 if there are no objections, and then wait as per proper
> process.
> 
> NAK

At your request 16 months ago, we did exactly that.
Further, we added build-time and run-time warnings and all they did
was cause distro mis-merges and requests to remove the warnings.

16 months ago we came within inches of dropping APM entirely,
as Stephen said he hadn't maintained it for a long time.
Jiri volunteered to look after it, and Pavel offered
that he had 1 surviving machine someplace that actually
supports APM, though I don't know if boots.

I don't dispute that there may be some APM systems running someplace,
but if nobody is going to test a 2012 kernel on such hardware,
then we are kidding ourselves if we say we "support" today's kernel on it.
Also, the whole idea was even if we do support such HW, this patch
is supposed to make that HW more stable, not less stable.

-Len

