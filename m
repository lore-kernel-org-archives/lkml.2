Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab0KST7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:59:33 -0500
Received: from mail.lang.hm ([64.81.33.126]:52662 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494Ab0KST7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:59:33 -0500
Date: Fri, 19 Nov 2010 11:58:20 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        w@1wt.eu, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
In-Reply-To: <AANLkTi=OsWEdrfCOHKz+SAtqo7DmK0nNxku7Ev21f0Lh@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1011191156470.19579@asgard.lang.hm>
References: <20101116104600.GA24015@suse.de> <20101119191906.GA31760@xanatos> <AANLkTi=OsWEdrfCOHKz+SAtqo7DmK0nNxku7Ev21f0Lh@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-511236603-1290196700=:19579"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-511236603-1290196700=:19579
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 19 Nov 2010, Linus Torvalds wrote:

> On Fri, Nov 19, 2010 at 11:19 AM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
>>
>> .config and dmesg are attached.  The box is running klogd 1.5.5ubuntu3
>> (from Jaunty).  Yes, I know that's old.  I read the bit in the commit
>> about changing the permissions of kallsyms after boot, but if I can't
>> boot that doesn't help.  Perhaps this can be made a configuration
>> option?
>
> It's not worth a config option.
>
> If it actually breaks user-space, I think we should just revert it.

how far back do we need to maintain compatibility with userspace?

Is this something that we can revisit in a few years and lock it down 
then?

David Lang

> It's kind of sad to default to the world-visible thing, but as I
> mentioned in the commit, this is something where a sysadmin or distro
> can trivially just fix it at boot-time too, with just a
>
>   chmod og-r /proc/kallsyms
>
> in your bootup scripts.
>
> And if somebody has taken control of the machine _before_ the bootup
> scripts get to run, you have bigger problems than a /proc/kallsyms
> file.
>
> So I guess I'll revert it.
>
> Thanks for testing and bisecting.
>
>                      Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
--680960-511236603-1290196700=:19579--
