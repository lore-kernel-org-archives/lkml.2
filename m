Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab1L0Bqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 20:46:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58723 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab1L0Bqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 20:46:43 -0500
Message-ID: <4EF92409.3090404@cn.fujitsu.com>
Date: Tue, 27 Dec 2011 09:48:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: move a check to parse_cgroupfs_options()
References: <4EF2EDA7.4010004@cn.fujitsu.com>	<20111222152011.GA17084@google.com>	<4EF3F834.0@cn.fujitsu.com> <CAOS58YMffJ4uH02H0TH_DmhtjQOVgz2_u_6HJqsGnR6PQ3ZGzw@mail.gmail.com>
In-Reply-To: <CAOS58YMffJ4uH02H0TH_DmhtjQOVgz2_u_6HJqsGnR6PQ3ZGzw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-27 09:45:55,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-27 09:45:56,
	Serialize complete at 2011-12-27 09:45:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> On Thu, Dec 22, 2011 at 7:40 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>> And where did this one go?
>>
>> The other one I removed sets opts->new_root to NULL, and this one detects
>> the NULL ptr:
>>
>> if (!opts->subsys_bits && !opts->none)
>>        return NULL;
>> ...
>> opts->new_root = NULL;
>> ...
>> if (!opts->new_root)
>>        return -EINVAL;
>>
>> shortcut to:
>>
>> if (!opts->subsys_bits && !opts->none)
>>        return -EINVAL;
> 
> Thanks for the explanation. Maybe explaining it briefly in the commit
> message would be nice?
> 

I recalled why we have this check in this place, that is to allow mounting
by hierarchy name, but it has been broken for a long time. I'll send a
fix with detailed changelog.
