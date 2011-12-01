Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab1LANNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 08:13:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42001 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab1LANNm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 08:13:42 -0500
MIME-Version: 1.0
In-Reply-To: <20111201125554.GC5706@redhat.com>
References: <20111129100727.GD2675@tiehlicka.suse.cz>
	<20111129113906.GA7299@redhat.com>
	<20111130101028.GA2906@tiehlicka.suse.cz>
	<20111130142316.GA2466@redhat.com>
	<20111130140316.GA4153@tiehlicka.suse.cz>
	<20111130153929.GA2144@redhat.com>
	<20111201085845.GA4602@tiehlicka.suse.cz>
	<20111201105538.GA4504@tiehlicka.suse.cz>
	<20111201115911.GA5706@redhat.com>
	<20111201124440.GB25614@tiehlicka.suse.cz>
	<20111201125554.GC5706@redhat.com>
Date: Thu, 1 Dec 2011 15:13:42 +0200
X-Google-Sender-Auth: mPqE9UtiQfX7O8ZqbeeIWT6J3IY
Message-ID: <CAB3XZEeNF8_U__rOPMfiOFNjPTS6gb33CSjdwkhMdRmS+i3CTw@mail.gmail.com>
Subject: Re: [3.2-rc3] 100% CPU usage while in del_timer_sync from iwl3945_rs_free_sta
From: Eliad Peller <eliad@wizery.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 2:55 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Thu, Dec 01, 2011 at 01:44:40PM +0100, Michal Hocko wrote:
>> On Thu 01-12-11 12:59:12, Stanislaw Gruszka wrote:
>> > On Thu, Dec 01, 2011 at 11:55:38AM +0100, Michal Hocko wrote:
>> > > [  349.316070] iwl3945_rs_free_sta rs_sta f4be1ac0
>> > > [  349.316076] ------------[ cut here ]------------
>> > > [  349.316097] WARNING: at drivers/net/wireless/iwlegacy/iwl-3945-rs.c:438 iwl3945_rs_free_sta+0x33/0x42 [iwl3945]()
>> >
>> > Johannes pointed on irc that this problem is most likely caused by:
>> >
>> > commit f785d83a19bca326f79d127a413e35769afc0105
>> > Author: Eliad Peller <eliad@wizery.com>
>> > Date:   Mon Aug 8 16:50:22 2011 +0300
>> >
>> >     mac80211: clear sta.drv_priv on reconfiguration
>> >
>> > Michal, could you confirm that? If that is the root of the problem, we
>> > need patch for iwlegacy (and iwlwifi) that allocate separate memory for
>> > rc structures.
> Actually this require quite big changes in iwlegacy at least, perhaps
> also in iwlwifi. I prefer to revert commit as temporary fix,  and add
> memset(0) to drivers .add_sta callback, in drivers which need it. After
> changing iwlegcy/iwlwifi we could move memset(0) back to ieee80211_reconfig().
>
> Eliad, thoughts?
>
i don't really care about temporarily reverting it.
but maybe you can just add an "initialized" flag to iwl3945_rs_sta,
and check it on free_sta?

Eliad.
