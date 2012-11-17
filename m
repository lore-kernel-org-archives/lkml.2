Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2KQKdB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 05:33:01 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:32932 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2KQKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 05:32:59 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1211162330090.19580@aurora.sdinet.de>
References: <CAPM=9twSHBet=vDY9q4BXKv7ZUPR-eme75tOzxrWf6Bsp4MMkw@mail.gmail.com>
 <1352795227.9466.8.camel@jlt4.sipsolutions.net> <CA+55aFw8Rx6TScXV_nsh4EFeCDTxsjn9mJPqo8VzPhbG9jC5Fw@mail.gmail.com>
 <1353098137.9490.20.camel@jlt4.sipsolutions.net> <1353098204.9490.21.camel@jlt4.sipsolutions.net>
 <1353098379.9490.22.camel@jlt4.sipsolutions.net> <alpine.DEB.2.02.1211162330090.19580@aurora.sdinet.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 17 Nov 2012 21:32:37 +1100
Message-ID: <CAGRGNgWZHvs2Fb-BLd+wgqz5WcmdBHvodvnHOBE_4+w7dqzRPg@mail.gmail.com>
Subject: Re: removal of sysfs wext extension broke on F16
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bill Nottingham <notting@redhat.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sven,

On Sat, Nov 17, 2012 at 9:32 AM, Sven-Haegar Koch <haegar@sdinet.de> wrote:
> On Fri, 16 Nov 2012, Johannes Berg wrote:
>
>> On Fri, 2012-11-16 at 21:36 +0100, Johannes Berg wrote:
>> > On Fri, 2012-11-16 at 21:35 +0100, Johannes Berg wrote:
>> > > On Fri, 2012-11-16 at 10:20 -0800, Linus Torvalds wrote:
>> > > > On Tue, Nov 13, 2012 at 12:27 AM, Johannes Berg
>> > > > <johannes@sipsolutions.net> wrote:
>> > > > >
>> > > > > Should I revert it and send it in my next pull request?
>> > > >
>> > > > Please do. Or perhaps we could just add the directory back, without
>> > > > the actual entries, if that is sufficient..
>> > >
>> > > Yeah, that does seem to be sufficient, I'll queue up the patch below.
>> >
>> > Err, no, wishful thinking. I need a *little* bit more for sysfs to work.
>>
>> This works, sorry about that.
>
>> +#if IS_ENABLED(CONFIG_WIRELESS_EXT) || IS_ENABLED(CONFIG_CFG80211)
>> +static struct attribute *wireless_attrs[] = {
>> +     NULL
>> +};
>> +
>> +static struct attribute_group wireless_group = {
>> +     .name = "wireless",
>> +     .attrs = wireless_attrs,
>> +};
>> +#endif
>>  #endif /* CONFIG_SYSFS */
>>
>
> How about a small comment in the source why it is there? I suppose
> otherwise in a year or two someone will find it, see "WTF? Useless
> empty directory?" and try to remove it again...

Hopefully by then Fedora's networking scripts won't need it =)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
