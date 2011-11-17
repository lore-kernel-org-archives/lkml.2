Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab1KQDgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 22:36:20 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:53342 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752155Ab1KQDgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 22:36:18 -0500
Message-ID: <4EC48122.8050800@st.com>
Date: Thu, 17 Nov 2011 09:06:02 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/5] mfd/stmpe: Pass partnum as param to stmpe_probe()
References: <cover.1321442150.git.viresh.kumar@st.com> <004126aa92b5c1e0d1b464409510fd5dd9771523.1321442150.git.viresh.kumar@st.com> <CAH+eYFA=S6Jk-dar4bsiogA2sJii0Q5Akuf3eoa9TRpLPe3G9Q@mail.gmail.com>
In-Reply-To: <CAH+eYFA=S6Jk-dar4bsiogA2sJii0Q5Akuf3eoa9TRpLPe3G9Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 9:05 PM, Rabin Vincent wrote:
> On Wed, Nov 16, 2011 at 16:56, Viresh Kumar <viresh.kumar@st.com> wrote:
>> partnum is required during probe to get variant's info. Currently partnum was
>> getting set in i2c interface after it is used and is not at all getting set in
>> spi interface.
> 
> So your previous patch is broken?  Please fix it and resend it instead
> since it's not merged yet.
> 

Sure.

>>
>> This can be passed as param to stmpe_probe, so that it is available early. With
>> this, there is no need of i2c interface's init() routine, as it does nothing
>> else than calling dev_set_drvdata(). So better remove this routine for i2c.
>>
>> partnum defined in struct stmpe is of no use now, as it is only used once during
>> probe of stmpe, so we can remove it from struct stmpe too.
> 
> Not quite; it's used from drivers/input/keyboard/stmpe-keypad.c.  Please
> preserve this stmpe->partnum, drop your 2/5 patch which exposes variant
> externally, and instead use stmpe->partnum in 5/5.

Yes, will do this.

-- 
viresh
