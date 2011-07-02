Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab1GBMFw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 08:05:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57274 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab1GBMFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 08:05:51 -0400
Message-ID: <4E0F0835.4090104@gmail.com>
Date: Sat, 02 Jul 2011 13:59:49 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sergiu Iordache <sergiu@chromium.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] char drivers: ramoops debugfs entry
References: <1309483720-1407-1-git-send-email-sergiu@chromium.org> <1309483720-1407-4-git-send-email-sergiu@chromium.org> <4E0E0D03.2080203@gmail.com> <BANLkTim_TVCq-oStBmLVVEPb5SRkA-HS7SuejXYn1kn1F+CwaA@mail.gmail.com> <4E0ED041.9030802@gmail.com> <CAGDaqBQSeWxhWU53rBnY8t61ueSh9=RkqTLqnAUjA28Lub8HdA@mail.gmail.com>
In-Reply-To: <CAGDaqBQSeWxhWU53rBnY8t61ueSh9=RkqTLqnAUjA28Lub8HdA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/07/2011 11:01, Sergiu Iordache ha scritto:
> On Sat, Jul 2, 2011 at 1:01 AM, Marco Stornelli
> <marco.stornelli@gmail.com>  wrote:
 >>
>> It was easy because the record size had a fixed length (4096), so maybe at
>> this point it can be sufficient the record size information. I see a little
>> problem however. I think we could use debugfs interface to dump the log in
>> an easy way but we should be able to dump it even with /dev/mem. Specially
>> on embedded systems, debugfs can be no mounted or not available at all. So
>> maybe, as you said below, with these new patches we need a memset over all
>> the memory area when the first dump is taken. However, the original idea was
>> to store even old dumps. In addition, there's the problem to catch an oops
>> after a start-up that "clean" the area before we read it. At that point we
>> lost the previous dumps. To solve this we could use a "reset" paramater, but
>> I think all of this is a little overkilling. Maybe we can only bump up the
>> record size if needed. What do you think?
> The problem with a fixed record size of 4K is that it is not very
> flexible as some setups may need more dump data (and 4K doesn't mean
> that much). Setting the record size via a module parameter or platform
> data doesn't seem as a huge problem to me if you are not using debugfs
> as you should be able to somehow export the record size (since you
> were the one who set it through the parameter in the first place) and
> get the dumps from /dev/mem.

The point here is not how to set record size, but what it does mean to 
have a variable record size compared with the current situation. 
However, if we know that there are situation where 4k are not 
sufficient, ok we can modify it.

>
> I've thought more about this problem today and I have thought of the
> following alternative solution: Have a debugfs entry which returns a
> record size chunk at a time by starting with the first entry and then
> checking each of the entries for the header (and the presence of the
> timestamp maybe to be sure). It will then return each entry that is
> valid skipping over the invalid ones and it will return an empty
> result when it reaches the end of the memory zone. It could also have
> an entry to reset to the first entry so you can start over. This way
> you wouldn't lose old entries and you could still get a pretty easy to
> parse result.
>

It seems a good strategy for me.

Marco
