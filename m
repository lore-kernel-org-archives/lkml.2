Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0KRBch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:32:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57525 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab0KRBcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:32:35 -0500
Message-ID: <4CE48265.5060803@cn.fujitsu.com>
Date: Thu, 18 Nov 2010 09:33:25 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Josef Bacik <josef@redhat.com>, viro <viro@zeniv.linux.org.uk>,
        Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ito <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH 1/3] direct-io: add a hook for the fs to provide its own
 bio merging check function
References: <4CE3579B.1000301@cn.fujitsu.com> <20101117070658.GF5618@dhcp231-156.rdu.redhat.com> <20101117093720.GG5618@dhcp231-156.rdu.redhat.com> <4CE3AA37.8060709@cn.fujitsu.com> <20101117125011.GH5618@dhcp231-156.rdu.redhat.com> <1290012777-sup-9103@think> <4CE47EDA.90205@cn.fujitsu.com> <1290043239-sup-7020@think>
In-Reply-To: <1290043239-sup-7020@think>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-18 09:32:53,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-18 09:32:55,
	Serialize complete at 2010-11-18 09:32:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 	wed, 17 Nov 2010 20:24:39 -0500, Chris Mason wrote:
> Excerpts from Miao Xie's message of 2010-11-17 20:18:18 -0500:
>>>> Right thats the idea, if we can't span chunks/stripes we should be doing that
>>>> limiting in our get_blocks call and that way we don't have to screw with the
>>>> generic direct io stuff too much.  Thanks,
>>>
>>> In this case we're adding complexity to the O_DIRECT mapping code, when
>>> we really should be adding it to the btrfs submit bio hook.  It can
>>> easily break up the bio into smaller units, which will leave us with a
>>> smaller number of get_blocks calls overall.
>>>
>>> I'm working that out now.
>>
>> Do you mean you are fixing this bug now?
>
> I started on it this afternoon, but lost network due to high winds here.
> So, I didn't make any real progress.
>
> If you'd like to fix this in the btrfs direct-io bio submit call you're
> welcome to continue working on it.
>
> The idea is to just clone and split up the bio, which will keep us from
> filling up fs/direct-io.c w/btrfs rules and allow us to take fewer
> trips into the get_blocks call.

Ok, I'll do it.

Thanks
Miao
