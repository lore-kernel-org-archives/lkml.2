Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab0FBDuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 23:50:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42650 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab0FBDuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 23:50:03 -0400
MIME-Version: 1.0
In-Reply-To: <20100601140519.GC1281@gvim.org>
References: <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com>
	<Pine.LNX.4.44L0.1005292026080.6300-100000@netrider.rowland.org>
	<AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
	<201005312338.55109.rjw@sisk.pl>
	<20100531232617.GF31155@gvim.org>
	<20100601090737.4bc243d9@schatten.dmk.lab>
	<20100601140519.GC1281@gvim.org>
Date: Tue, 1 Jun 2010 20:50:02 -0700
Message-ID: <AANLkTikF-B23_UWG1O3tlBl4m8NStAJllGhhevNhYZT6@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: markgross@thegnar.org
Cc: Florian Mickler <florian@mickler.org>, 640e9920@gmail.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 7:05 AM, mark gross <640e9920@gmail.com> wrote:
> On Tue, Jun 01, 2010 at 09:07:37AM +0200, Florian Mickler wrote:
...
>> +static void update_target_val(int pm_qos_class, s32 val)
>> +{
>> +     s32 extreme_value;
>> +     s32 new_value;
>> +     extreme_value = atomic_read(&pm_qos_array[pm_qos_class]->target_value);
>> +     new_value = pm_qos_array[pm_qos_class]->comparitor(val,extreme_value);
>> +     if (extreme_value != new_value)
>> +             atomic_set(&pm_qos_array[pm_qos_class]->target_value,new_value);
>> +}
>> +
>
> Only works 1/2 the time, but I like the idea!
> It fails to get the righ answer when constraints are reduced.  But, this
> idea is a good improvement i'll roll into the next pm_qos update!
>

I think it would be a better idea to track your constraints with a
sorted data structure. That way you can to better than O(n) for both
directions. If you have a lot of constraints with the same value, it
may even be worthwhile to have a two stage structure where for
instance you use a rbtree for the unique values and list for identical
constraints.

-- 
Arve Hjønnevåg
