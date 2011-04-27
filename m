Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab1D0Oag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:30:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:40982 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab1D0Oae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:30:34 -0400
Message-ID: <4DB82884.80706@infradead.org>
Date: Wed, 27 Apr 2011 11:30:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v4l: make sure drivers supply a zeroed struct v4l2_subdev
References: <1301677922-6765-1-git-send-email-herton.krzesinski@canonical.com> <201104021005.57200.hverkuil@xs4all.nl> <201104270839.34066.hverkuil@xs4all.nl>
In-Reply-To: <201104270839.34066.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-04-2011 03:39, Hans Verkuil escreveu:
> On Saturday, April 02, 2011 10:05:57 Hans Verkuil wrote:
>> On Friday, April 01, 2011 19:12:02 Herton Ronaldo Krzesinski wrote:
>>> Some v4l drivers currently don't initialize their struct v4l2_subdev
>>> with zeros, and this is a problem since some of the v4l2 code expects
>>> this. One example is the addition of internal_ops in commit 45f6f84,
>>> after that we are at risk of random oopses with these drivers when code
>>> in v4l2_device_register_subdev tries to dereference sd->internal_ops->*,
>>> as can be shown by the report at http://bugs.launchpad.net/bugs/745213
>>> and analysis of its crash at https://lkml.org/lkml/2011/4/1/168
>>>
>>> Use kzalloc within problematic drivers to ensure we have a zeroed struct
>>> v4l2_subdev.
>>>
>>> BugLink: http://bugs.launchpad.net/bugs/745213
>>> Cc: <stable@kernel.org>
>>> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
>>
>> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Mauro,
> 
> Please get this patch upstream! It's a nasty 2.6.38 regression that needs to
> be upstreamed urgently. The fix is simple and solves oopses in several
> drivers. 2.6.38 can't be fixed as long as this fix isn't in 2.6.39.

(11:18:42) hverkuil: mchehab: ping
(11:21:01) hverkuil: mchehab: please add the 'make sure drivers supply a zeroed struct v4l2_subdev' patch to the 2.6.39 pull request!
(11:21:53) hverkuil: It fixes a 2.6.38 regression and it really needs to be upstreamed asap.


I intend to add it on the next series. As you know, patches need to go first to -next
tree before being merged. Unfortunately, patchwork is broken for about one week. A mysql
replication error damaged the database, and about 270 patches got lost. kernel.org
maintainer is working on a way to re-add the missing patches.

Mauro.
