Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1GMU7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:59:23 -0400
Received: from smtp-out.google.com ([74.125.121.67]:2373 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1GMU7V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:59:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=E7ECuiBIclyjZJqcJpL146Nt1W/Bgfx41i3M/zSGFjqDd0CIqUcJtWaT6uhB3uuSH
	DS2kxHt0ZK71Caia5e+ug==
MIME-Version: 1.0
In-Reply-To: <CAPz6YkVsnZk0WA+Y-cOTtX4=VQd2=peOyKCD4aHdUXCy3=GDaw@mail.gmail.com>
References: <1310505348-20163-1-git-send-email-sonnyrao@chromium.org>
 <29926.1310553581@neuling.org> <30671.1310554369@neuling.org>
 <1310589536.3931.25.camel@gandalf.stny.rr.com> <CAPz6YkVsnZk0WA+Y-cOTtX4=VQd2=peOyKCD4aHdUXCy3=GDaw@mail.gmail.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Wed, 13 Jul 2011 13:58:58 -0700
X-Google-Sender-Auth: 5Ni2ostk0dqiHNC6BUvxKt97194
Message-ID: <CAPz6YkW_iHA26+aDBrbiUOKSa_kXuVxO-uiuShHVO89cniS+vw@mail.gmail.com>
Subject: Re: [PATCH] [RFC] perf: robustify proc and debugfs file recording
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Neuling <mikey@neuling.org>, acme@redhat.com, anton@samba.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 1:49 PM, Sonny Rao <sonnyrao@chromium.org> wrote:
> On Wed, Jul 13, 2011 at 1:38 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Wed, 2011-07-13 at 20:52 +1000, Michael Neuling wrote:
>>
>>> Actually, here's an updated patch to fix these..
>>>
>>> FYI perf record/annotate/report works fine on my powerpc box here with
>>> this.  I don't have modules handy so I've not tested that aspect.
>>
>> Sure it worked for you...
>>
>>
>>> -static unsigned long get_size(const char *file)
>>> -{
>>> -     unsigned long long size = 0;
>>> -     int fd;
>>> -
>>> -     fd = open(file, O_RDONLY);
>>> -     if (fd < 0)
>>> -             die("Can't read '%s'", file);
>>> -     size = get_size_fd(fd);
>>>       close(fd);
>>>
>>> -     return size;
>>> +     /* ugh, handle big-endian hdr_size == 4 */
>>> +     sizep = (char*)&size;
>>> +     if (bigendian())
>>> +             sizep += sizeof(u64) - hdr_sz;
>>> +
>>> +     if (pwrite(output_fd, &size, hdr_sz, hdr_pos) < 0)
>>
>> s/&size/sizep/
>
> Argh, I'm really messing this up... so yeah this shouldn't have worked
> on big-endian without that fix..
> Mikey, are you sure it worked?

Actually, I think you need to use tracepoints or this code won't be invoked.
So, please try with some tracepoints, thanks.

Sonny
