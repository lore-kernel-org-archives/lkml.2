Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab1DFWPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:15:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33328 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab1DFWPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:15:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OEvhHWxd2PSdODfpwcuRJT4WYAhj0/4uIjkmzACgXweNR8GZvVkPG1oWNuaCcwifKm
         IACFtp2OPN/JziQ12kHbuv+ZWD96rpn5vQOa1Y2QoQX5aw61LLWjCmSUaQEZ9RpmIXx/
         FemNJRUeLzAcOpcv5j9kOj3mrXTQ/c5+raIh0=
Message-ID: <4D9CE610.4020603@gmail.com>
Date: Wed, 06 Apr 2011 16:15:44 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [2.6.39-rc2] perf top fails to mmap
References: <inhgjs$54a$1@dough.gmane.org> <4D9C84D5.6090303@gmail.com> <20110406175217.GC4987@ghostprotocols.net> <201104062248.23853.tim@klingt.org>
In-Reply-To: <201104062248.23853.tim@klingt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/06/11 14:48, Tim Blechmann wrote:
>>> David
>>>
>>>> this happens when running perf as the same process as the process and
>>>> when running perf as root.
>>
>> yep, works for me as well:
>>
>> [acme@emilia ~]$ cat vsyscall.c
> 
> after including unistd.h, this compiles and works fine. however i cannot profile 
> any multithreaded program. does this work for you?
> 
> tim
> 

That does fail:
# ps -C rsyslogd -L
  PID   LWP TTY          TIME CMD
  795   795 ?        00:00:00 rsyslogd
  795   797 ?        00:00:00 rsyslogd
  795   798 ?        00:00:00 rsyslogd

# /tmp/build-perf/perf top -p 795
Failed to mmap with 22 (Invalid argument)

strace shows it failing at:
ioctl(4, PERF_EVENT_IOC_SET_OUTPUT, 0x3) = -1 EINVAL (Invalid argument)

Changing to use thread only works:
# /tmp/build-perf/perf top -t 795
