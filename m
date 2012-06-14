Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab2FNUAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:00:39 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53545 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab2FNUAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:00:23 -0400
Message-ID: <4FDA42CC.2090807@landley.net>
Date: Thu, 14 Jun 2012 15:00:12 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Wen Congyang <wency@cn.fujitsu.com>,
        tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] x86: add max_addr boot option
References: <4FD5AFF2.3040306@cn.fujitsu.com> <CAErSpo6EnHFFPwcPhWy=ACTn5+7i72fUR+1jjZrpfEMQp1zv0A@mail.gmail.com> <4FD6E1DA.2090700@cn.fujitsu.com> <CAErSpo6UwL6kY4rHeYQbn1kghJH-kQDeat7VXp95JE2pGER5ZA@mail.gmail.com> <4FD7F329.1000203@jp.fujitsu.com> <4FD81E27.4000006@landley.net> <4FD94738.6030500@jp.fujitsu.com>
In-Reply-To: <4FD94738.6030500@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 09:06 PM, Kamezawa Hiroyuki wrote:
>> You're adding an option because you consider it less confusing for your
>> end users who are digging into kernel parameters, but you will set this
>> new option for your users because they haven't got the information to
>> set it themselves?
>>
> 
> My users don't need to know about hardware settings and the meaning of
> kernel params. They'll just do as we ask to do.

So you're adding a new feature that only you will use, because the
existing way of doing it confuses... you.

>> So you're saying there are already two ways to do this, but you want to
>> add a third to be less confusing for end users who are modifying the
>> linux kernel boot parameters by hand using information only you can
>> supply to them?
>>
>> I'm confused...
>>
> 
> I'm just saying current mem= implemenation seems buggy because spec. and
> impl. doesn't match. So, we're just afraid that someone other than us
> will fix it and break our assumption how mem= works. It's dangerous to
> build a production on a feature where spec. and impl. doesn't match.
> So, we proposed to add max_addr= option for avoiding that situation.

So fix the spec, or fix the implementation. Don't add a random new
duplicate way to do the same thing because you're afraid that open
source code might change, but somehyow the new code you propose to add
won't (presumably due to being so profoundly uninteresting to the rest
of the world that nobody will notice it's there).

Sigh.  On arm you can go "mem=size@start", which can be repeated. I.E.
you can, on the kernel command line, tell it where all the chunks of
physical memory it should use actually live. Letting x86 do that might
be nice. Adding a clipping option to the normal memory probing, so
memory probing has to fail in a certain specific way in order for this
to even apply? Not so much...

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
