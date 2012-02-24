Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab2BXOmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:42:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57486 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab2BXOmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 09:42:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rabin.vincent@gmail.com designates 10.50.156.166 as permitted sender) smtp.mail=rabin.vincent@gmail.com; dkim=pass header.i=rabin.vincent@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAOh2x=kDxqddm8EdRKp0+38Efs2QX33TtofLgLxe6auex0YZWQ@mail.gmail.com>
References: <2f2b55523b707d514a15d822ff812cfae654510a.1330079584.git.viresh.kumar@st.com>
 <CAH+eYFAEnWdvzojefix_iAefUK3BnLQNcwP2xY0vLHf5RLj5eg@mail.gmail.com> <CAOh2x=kDxqddm8EdRKp0+38Efs2QX33TtofLgLxe6auex0YZWQ@mail.gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Fri, 24 Feb 2012 20:12:11 +0530
X-Google-Sender-Auth: ra_d5mLAACQOyPJmgBLnJT6-ycs
Message-ID: <CAH+eYFCzL5bmnjDMvT5sH=gcDjnStYWCWWeVq_hMjUk9g=+-9w@mail.gmail.com>
Subject: Re: [PATCH] gpio/gpio-stmpe: Fix the value returned by _get_value routine
To: viresh kumar <viresh.linux@gmail.com>
Cc: salvatore.dedominicis@st.com, bhavna.yadav@st.com, rajeev-dlh.kumar@st.com,
        Viresh Kumar <viresh.kumar@st.com>, pratyush.anand@st.com,
        shiraz.hashim@st.com, grant.likely@secretlab.ca, deepak.sikri@st.com,
        mirko.gardi@st.com, vipulkumar.samar@st.com,
        linus.walleij@stericsson.com, armando.visconti@st.com,
        amit.virdi@st.com, vincenzo.frascino@st.com, vipin.kumar@st.com,
        linux-kernel@vger.kernel.org, bhupesh.sharma@st.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 19:59, viresh kumar <viresh.linux@gmail.com> wrote:
> On Feb 24, 2012 7:46 PM, "Rabin Vincent" <rabin@rab.in> wrote:
>> On Fri, Feb 24, 2012 at 16:04, Viresh Kumar <viresh.kumar@st.com> wrote:
>> > The present _get_value routine returns the contents of the GPIO
>> > Monitor Pin Status Register(GPMR) starting from the bit whose value
>> > is requested to BIT 0.
>> >
>> > For e.g. if we request the value of GPIO 6 in the earlier
>> > implementation the value returned is:
>> >
>> >        BIT6 to BIT0
>> >
>> > whereas it should just return BIT6.
>>
>> The current implementation just returns (ret & mask) where mask
>> would have only BIT6 set, so how can it return "BIT6 to BIT0" ?
>
> Oops! I gave same comment when i saw this patch
> on our internal list and i forgot to fix log while applying.
>
> It actually returns 0b1000000 for example. And we need 1 here.

According to the documentation, gpio_get_value() (i.e. this function)
can return zero or non-zero, not necessarily zero or one.
