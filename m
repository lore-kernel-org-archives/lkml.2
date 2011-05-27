Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128Ab1E0EmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:42:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42981 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1E0EmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:42:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jVKnhYAo+3YSdQbBndv+wtNm3doFCt/6OtqOn0KPnQVUoYokSBU0phD60SjqKVfJpS
         BSdnBBWiOiiTn7VNknEVvFQ1mSwPi7Lx11kowNkEvJeIzXplEOX43NMveJ/xOanplm++
         cLbpfcMkORZNUBwAhafmEeON4pzSYdvaEr/rU=
MIME-Version: 1.0
In-Reply-To: <201105182146.51869.rjw@sisk.pl>
References: <1305100723-29161-1-git-send-email-myungjoo.ham@samsung.com>
	<201105180039.56806.rjw@sisk.pl>
	<BANLkTim0DkhcjWw7fM0e-UhyB3=GkQ7nKw@mail.gmail.com>
	<201105182146.51869.rjw@sisk.pl>
Date: Fri, 27 May 2011 13:42:18 +0900
Message-ID: <BANLkTi=dbX7LqqKrmgb0tSJhC26r7-L3Eg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] PM / DEVFREQ: add example governors
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mark Brown <broonie@sirena.org.uk>, Jiejing Zhang <kzjeef@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Colin Cross <ccross@google.com>,
        Nishanth Menon <nm@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 4:46 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, May 18, 2011, MyungJoo Ham wrote:
>> 2011/5/18 Rafael J. Wysocki <rjw@sisk.pl>:
>> > On Wednesday, May 11, 2011, MyungJoo Ham wrote:
>> >> Three CPUFREQ-like governors are provided as examples.
>> >>
>> >> powersave: use the lowest frequency possible. The user (device) should
>> >> set the polling_ms as 0 because polling is useless for this governor.
>> >>
>> >> performance: use the highest freqeuncy possible. The user (device)
>> >> should set the polling_ms as 0 because polling is useless for this
>> >> governor.
>> >>
>> >> simple_ondemand: simplified version of CPUFREQ's ONDEMAND governor.
>> >>
>> >> When a user updates OPP entries (enable/disable/add), OPP framework
>> >> automatically notifies DEVFREQ to update operating frequency
>> >> accordingly. Thus, DEVFREQ users (device drivers) do not need to update
>> >> DEVFREQ manually with OPP entry updates or set polling_ms for powersave
>> >> , performance, or any other "static" governors.
>> >
>> > Well, do you expect anyone to actually use them?  If not, it would make
>> > more sense to put them into a doc.
>>
>> According to our experiences of DVFS(although this "DEVFREQ" is not
>> applied to them, yet) in memory-bus and GPU,
>> I expect most DEVFREQ users might use "simple_ondemand" and
>> expect "powersave" and "performance" will probably mostly used while
>> testing and debugging.
>> ("userspace"-like governor would be also useful for that purpose, but
>> I'd add it later)
>
> It would be good to have at least one in-tree user for each of them
> (not necessarily from the start, but at one point in the future at least).
>
> So if you have any _specific_ users in mind, please let me know.

For Exynos4, the DRAM bus, which is included in cpufreq and altered
along with CPU, but would be better to alter independently, and the
G3D core (MALI) are the candidate. In our kernel hacks, the DRAM bus
frequency varies independently from CPU with DRAM usage monitoring and
I think it can be easily modified to use DEVFREQ; thus, I'm going to
"translate" this to DEVFREQ next time. For MALI, I don't know whether
there is non-copyrighted driver or now, but they do support DVFS and
are using DVFS with some PITA driver support.

These two (EXYNOS4 DRAM bus and MALI) are the specific users in mind for now.
Probably, out-of-SoC devices such as WiFi, BT, and others may be the
candidate as well.

>
> Thanks,
> Rafael
>



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
