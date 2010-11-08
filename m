Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab0KHF0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 00:26:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60755 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab0KHF0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 00:26:43 -0500
Message-ID: <4CD78A5A.30309@cn.fujitsu.com>
Date: Mon, 08 Nov 2010 13:27:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 7/7] cgroups: Update documentation for bindable subsystems
References: <4CC146A4.9090505@cn.fujitsu.com> <4CC14769.2000406@cn.fujitsu.com> <AANLkTinbtLkF=haFeDkzecEWv_FE9jG4TefiptSnZcPi@mail.gmail.com>
In-Reply-To: <AANLkTinbtLkF=haFeDkzecEWv_FE9jG4TefiptSnZcPi@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-08 13:27:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-08 13:27:12,
	Serialize complete at 2010-11-08 13:27:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
>>  Called when a cgroup subsystem is rebound to a different hierarchy
>> -and root cgroup. Currently this will only involve movement between
>> -the default hierarchy (which never has sub-cgroups) and a hierarchy
>> -that is being created/destroyed (and hence has no sub-cgroups).
>> +and root cgroup. For some subsystems this will only involve movement
>> +between the default hierarchy (which never has sub-cgroups) and a
>> +hierarchy that is being created/destroyed (and hence has no sub-cgroups).
>> +For some other subsystems this can involve movement between the default
>> +hierarchy and a mounted hierarchy which may have sub-cgroups in it.
> 
> This is a bit vague. How about:
> 
> For non-bindable subsystems, this will  only involve movement
> between the default hierarchy (which never has sub-cgroups) and a
> hierarchy that is being created/destroyed (and hence has no sub-cgroups).
> 
> For binadable subsystems, this may also involve movement between the
> default hierarchy and a mounted hierarchy that's populated with
> sub-cgroups.
> 
> Also, the docs should mention that a cgroup setting the can_bind flag
> has to be able to support side-effect free movement of a task into any
> just-created cgroup, and into the root cgroup at any time. i.e. it's
> not suitable for any subsystem where can_attach() might return false
> for the root cgroup or a newly-created cgroup, or attach() might have
> side-effects for those same cases.
> 
> Actually, perhaps we should forbid the combination of having both an
> attach() callback and can_bind=true ?
> 
> Also, post_clone() doesn't get called when creating the css hierarchy
> during binding.
> 

This is much better. :)

Documentation often causes my headache due to my limited English skill.
