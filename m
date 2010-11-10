Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0KJAvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:51:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51385 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0KJAvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:51:24 -0500
Message-ID: <4CD9ECD2.3030805@cn.fujitsu.com>
Date: Wed, 10 Nov 2010 08:52:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/7] cgroups: Shrink struct cgroup_subsys
References: <4CC146A4.9090505@cn.fujitsu.com>	<4CC146BA.7080009@cn.fujitsu.com>	<AANLkTikf-1kLStxqi5UjP=vn3pqVBHy0OA7ibeWTkJ5z@mail.gmail.com>	<4CD78946.5060405@cn.fujitsu.com> <AANLkTim6d1fQLZbkmZST3PTN0RMSs3m=oossF81pYBn9@mail.gmail.com>
In-Reply-To: <AANLkTim6d1fQLZbkmZST3PTN0RMSs3m=oossF81pYBn9@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-10 08:51:47,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-10 08:51:51,
	Serialize complete at 2010-11-10 08:51:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Sun, Nov 7, 2010 at 9:23 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> bool active;
>> bool disabled;
>> ...
>>
>> ?
>>
>> With alignment 5-8 bool values == 8 bytes in 64-bit machine, compared to
>> 4 bytes with the approach this patch takes.
> 
> I meant specifying it as:
> 
> bool active:1;
> bool disabled:1;
> 

It won't compile, but unsigned char active:1 will do. ;)

> i.e. keeping the bit-sized flags but also keeping the bool semantics.
> Having said that, I'm not really sure why saving 12 bytes per
> subsystem is worth a patch.

Every thing that reduces code size (without sacrifice readability
and maintain maintainability) should be worth.

This is one of the reasons we accept patches that replacing
kmalloc+memset with kzalloc, which just saves 8 bytes in my box.
