Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218Ab0KHFZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 00:25:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55488 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab0KHFZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 00:25:03 -0500
Message-ID: <4CD789F5.4000208@cn.fujitsu.com>
Date: Mon, 08 Nov 2010 13:26:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 2/7] cgroups: Allow to bind a subsystem to a cgroup hierarchy
References: <4CC146A4.9090505@cn.fujitsu.com> <4CC146D4.7030009@cn.fujitsu.com> <AANLkTimCD90s+y_6y=LyOL1QqEOOAaT+b2b4guDrzo_g@mail.gmail.com>
In-Reply-To: <AANLkTimCD90s+y_6y=LyOL1QqEOOAaT+b2b4guDrzo_g@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-08 13:25:30,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-08 13:25:31,
	Serialize complete at 2010-11-08 13:25:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Oct 22, 2010 at 1:09 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> +       /*
>> +        * Indicate if this subsystem can be bound/unbound to/from a cgroup
>> +        * hierarchy which has child cgroups.
>> +        */
>> +       unsigned int can_bind:1;
> 
> Maybe call this "bindable"?
> 
> Basic idea looks great, it could do with a bunch more comments, and
> maybe locking rules.
> 
> Is there any chance of a lock inversion between dir->i_mutex and
> cgroup_lock in hierarchy_popuiate_dir() ?
> 

The lock order is:

mutex_lock(&dir->i_mutex)
  mutex_lock(&cgroup_mutex)
    mutex_lock(&dir->i_mutex, I_MUTEX_CHILD)

it should be safe.
