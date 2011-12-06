Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1LFSNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:13:15 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51231 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1LFSNO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:13:14 -0500
MIME-Version: 1.0
In-Reply-To: <20111206095456.GB1342@tiehlicka.suse.cz>
References: <CABexPfE84OgdGQtKUm2JQ9_5ZBFs_pr3gdxMLYmxd=wVyBZhpQ@mail.gmail.com>
	<CABexPfFZ8LJxmsuiSOtejfVebrTRM3=ppW5hxbQgmgX04VdAOA@mail.gmail.com>
	<20111206095456.GB1342@tiehlicka.suse.cz>
Date: Wed, 7 Dec 2011 02:13:13 +0800
Message-ID: <CABexPfHvvsymd0ZZxWzp=E0PdUXgfzRDu32Wx+xs7ciiCM6scw@mail.gmail.com>
Subject: Re: [Page Allocator] when is init_per_zone_wmark_min called to first
 initialize the watermarks, reserved memory etc?
From: zhihua che <zhihua.che@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/6 Michal Hocko <mhocko@suse.cz>:
> On Tue 06-12-11 03:25:29, zhihua che wrote:
>> 2011/12/6 zhihua che <zhihua.che@gmail.com>:
>> > Hi, everyone
>> >
>> >        I'm reading the linux kernel codes, and now focusing on memory
>> > management. I came across a simple problem:).
>> >        I know the every zone keeps three water marks to control the
>> > allocator's behavior and I find the three watermarks is initialized in
>> > init_per_zone_wmark_min.
>> > Unfortunately, I can't find when this function is called FIRSTduring
>> > the kernel booting process. I searched the source codes using LXR and
>> > cscope and got nothing.
>> > I guess I missed something but I have no any idea.
>> >
>> > harvey.
>>
>>
>> Maybe I'm closer the truth:-)
>> I find this function is defined as a module entry function (I should'v
>> found this earlier). As far as I know module entry functions are
>> called at the end of start_kernel() by rest_init(), whereas page
>> allocator / buddy system is used before they are called. For example,
>> __get_free_pages() is called in kmem_cache_init() which in turn is
>> called in start_kernel() earlier than rest_init().
>
> Yes, this is correct. We do live without watermarks (resp. with 0) for
> some time and we rely that we have sufficient memory for that time (who
> we would reclaim from when no processes exist - apart from init and few
> kernel threads).
> kswapd is started around the same time.
>
> HTH
> --

Thanks for your tips. I think it helps.
