Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab1LNCHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:07:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60688 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab1LNCHf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:07:35 -0500
Message-ID: <4EE80564.7030608@cn.fujitsu.com>
Date: Wed, 14 Dec 2011 10:09:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, cgroups@vger.kernel.org,
        bsingharora@gmail.com, devel@openvz.org,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 3/3] make 'none' field a flag
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-5-git-send-email-glommer@parallels.com> <20111213154108.GF25802@google.com>
In-Reply-To: <20111213154108.GF25802@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-14 10:06:58,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-14 10:07:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年12月13日 23:41, Tejun Heo 写道:
> On Sun, Dec 11, 2011 at 03:45:38PM +0100, Glauber Costa wrote:
>> There is no reason to have a flags field, and then a separate
>> bool field just to indicate if 'none' subsystem were explicitly
>> requested.
>>
>> Make it a flag
>>
>> Signed-off-by: Glauber Costa <glommer@parallels.com>
> 
> Same as the previous patch.  Doesn't this change how remount
> conditions are checked?
> 

Right. The patch prevents us from doing:

	# mount -t cgroup -o none,name=tmp xxx /mnt
	# mount -o remount,cpuset xxx /mnt
	(failed)
