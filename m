Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab0EZIek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:34:40 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:35309 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443Ab0EZIei convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:34:38 -0400
From: Sundar R IYER <sundar.iyer@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sundar <sunder.svit@gmail.com>
Cc: Viresh KUMAR <viresh.kumar@st.com>, Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       Armando VISCONTI <armando.visconti@st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Date: Wed, 26 May 2010 10:33:49 +0200
Subject: RE: [linux-pm] Power Domain Framework
Thread-Topic: [linux-pm] Power Domain Framework
Thread-Index: Acr68qT8GAnqyN0KTEihgw7nHLo6+wBunhHQ
Message-ID: <33A307AF30D7BF4F811B1568FE7A9B180B67C60C@EXDCVYMBSTM006.EQ1STM.local>
References: <AANLkTiniwUDg8rQzwgm_X7EbkQJ9tHzBfVtaJRiNE9az@mail.gmail.com>
 <1274114107.20589.64.camel@bnru01>
 <1274115886.2698.22.camel@finisterre.wolfsonmicro.main>
 <1274118332.17303.17.camel@bnru01>
 <CEE6BB42CAD6E947908279175AF8470A025A726240@EXDCVYMBSTM006.EQ1STM.local>
 <1274131108.2698.161.camel@finisterre.wolfsonmicro.main>
 <CEE6BB42CAD6E947908279175AF8470A025A72624A@EXDCVYMBSTM006.EQ1STM.local>
 <1274134636.2698.170.camel@finisterre.wolfsonmicro.main>
 <1274162450.17303.35.camel@bnru01>
 <AANLkTinTdTp_X4lGtZ0hCaVJN5GmvI0tXR1RTRkRNkjN@mail.gmail.com>
 <20100524033859.GB24480@opensource.wolfsonmicro.com>
In-Reply-To: <20100524033859.GB24480@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

>-----Original Message-----
>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>This is just one example of something that might come up and need
>fitting in to the regulator API which is substantially different to the
>needs of the core regulator applications.  As I keep saying I'm just not
>seeing much more overlap here with the regulator API than I do with the
>clock API: it feels like you've got another use case which needs an API
>with a similar structure and the reference counted enable and disable
>calls but otherwise very little overlap.

As I agreed earlier, its true about requirement. It is also true that the clock API can suffice.
But what is essential here is: we are talking about regulators here.
Why would we need to model a seemingly similar regulator as a clock?

>I don't think the enable and disable calls are enough of an overlap to
>mean that the regulator use case and the operating point use case are
>going to overlap well, it feels like it'd cause pain trying to match the
>concepts between the two APIs.

Again here, more similarities for a power domain with a regulator.

1. Both power domains and a regulator can be enabled/disabled.
2. Both power domains and a regulator can be controlled to a specific voltage.
3. Every peripheral is dependent on both power domains and a regulator to be essentially
   on. Turning off the clocks will disable the peripheral, but it is not the same as turning off
   the peripheral. And here is where the biggest difference from the clock API. You can disable
   the peripheral clock with the clk_disable, but turning it off will be encroachment there. Whilst
   a regulator_disable is the most logical fit here.
4. Both power domains and a regulator can be enforced upon constraints from their clients.

*What* power domains and regulators differ about is:
1.a the nature of constraints is a bit different. On SoC regulators aka power domains have usually
     a fixed set of clients which don't vary, but off SoC regulators can have varying clients.
2.a On SoC regulators aka power domains allow you controlling operational states like 
     On/Off/Retention/Idle etc, whilst conventional regulators are more happy judging their current loads.
     However, this still doesn't stop anyone from actually adding operational states to regulators.

I agree with your reservations about pains trying to co-relate exactly a power domain and a regulator.
If you agree, from the top, reaching out to bottom, there are only subtle differences and these 
differences (1.a/2.a) can also be incorporated into conventional regulators which can be gradually 
diminishing, whereas the similarities, (1,2,3,4) can only possible increase!

Thanks,
Sundar

