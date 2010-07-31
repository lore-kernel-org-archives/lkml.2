Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab0GaDjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 23:39:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42239 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372Ab0GaDjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 23:39:52 -0400
X-User-Agent: K-9 Mail for Android
References: <1280448826-12004-1-git-send-email-fenghua.yu@intel.com> <1280448826-12004-3-git-send-email-fenghua.yu@intel.com> <4C537514.9090109@zytor.com> <20100731011339.GB28386@ericsson.com>
In-Reply-To: <20100731011339.GB28386@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3 2/5] Package Level Thermal Control and Power Limit Notification: pkgtemp hwmon driver
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 30 Jul 2010 20:04:10 -0700
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>, Huaxu Wan <huaxu.wan@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Message-ID: <b908df2f-5264-4680-bb3f-1fe427c02eeb@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the typedef keyword (see coretemp.c) it would be a typename... which is different from a tag in C (but not C++).

"Guenter Roeck" <guenter.roeck@ericsson.com> wrote:

>On Fri, Jul 30, 2010 at 08:57:56PM -0400, H. Peter Anvin wrote:
>> On 07/29/2010 05:13 PM, Fenghua Yu wrote:
>> > +
>> > +enum { SHOW_TEMP, SHOW_TJMAX, SHOW_TTARGET, SHOW_LABEL, SHOW_NAME } SHOW;
>> > +
>> 
>> This conflicts with an equally poorly named global variable in
>> drivers/hwmon/via-cputemp.c, and the conflict is causing a build failure.
>> 
>> I think both these drivers have the same bug: a missing "typedef" before
>> the enum keyword, as present in coretemp.c.  Of course, one can question
>> if it should be given a typename at all since in none of these drivers
>
>Especially since it isn't really a type name, but a global variable named SHOW.
>Type name (also called tag) would be enum SHOW { ... }; . 
>
>Guenter
>
>> they are actually referenced by type, and instead the enumeration is
>> just used as a source of constants, which can perfectly well be handled
>> with an unnamed enum:
>> 
>> enum { SHOW_TEMP, SHOW_TJMAX, SHOW_TTARGET, SHOW_LABEL, SHOW_NAME };
>> 
>> 	-hpa

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
