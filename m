Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965383Ab1GMRqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 13:46:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14122 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964816Ab1GMRqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 13:46:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=tNMQe+7fnPiXmdOS5Gna/X5EAQGk3yKe76qzCxN1BZOjDf1m1whBDRA5aKpCBUAOZ
	qQ7kToSLGyHs0Ofu7xqOQ==
MIME-Version: 1.0
In-Reply-To: <30671.1310554369@neuling.org>
References: <1310505348-20163-1-git-send-email-sonnyrao@chromium.org>
 <29926.1310553581@neuling.org> <30671.1310554369@neuling.org>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Wed, 13 Jul 2011 10:45:59 -0700
X-Google-Sender-Auth: RJe9khHUCoLWYfLXLYOP5QejlZU
Message-ID: <CAPz6YkVz=S2YcULXTPSvE+PEnDBif1wRRRGiGPeGBEuy=YUUuQ@mail.gmail.com>
Subject: Re: [PATCH] [RFC] perf: robustify proc and debugfs file recording
To: Michael Neuling <mikey@neuling.org>
Cc: acme@redhat.com, anton@samba.org, rostedt@goodmis.org,
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

On Wed, Jul 13, 2011 at 3:52 AM, Michael Neuling <mikey@neuling.org> wrote:
> In message <29926.1310553581@neuling.org> you wrote:
>> Sonny,
>>
>>
>> > While attempting to create a timechart of boot up I found
>> > perf didn't tolerate modules being loaded/unloaded.  This patch
>> > fixes this by reading the file once and then writing the size
>> > read at the correct point in the file.  It also simplifies the
>> > code somewhat.
>>
>> I'm getting a bunch of unused variables warnings when I compile this.
>> Care to clean them up?
>>
>>     CC util/trace-event-info.o
>> util/trace-event-info.c: In function =E2=80=98read_header_files=E2=80=99:
>> util/trace-event-info.c:221:27: error: unused variable =E2=80=98check_size=
>> =E2=80=99 [-Werror=3Dunused-variable]
>> util/trace-event-info.c:221:21: error: unused variable =E2=80=98size=E2=80=
>> =99 [-Werror=3Dunused-variable]
>> util/trace-event-info.c: In function =E2=80=98copy_event_system=E2=80=99:
>> util/trace-event-info.c:255:27: error: unused variable =E2=80=98check_size=
>> =E2=80=99 [-Werror=3Dunused-variable]
>> util/trace-event-info.c:255:21: error: unused variable =E2=80=98size=E2=80=
>> =99 [-Werror=3Dunused-variable]
>> util/trace-event-info.c: In function =E2=80=98read_proc_kallsyms=E2=80=99:
>> util/trace-event-info.c:377:21: error: unused variable =E2=80=98check_size=
>> =E2=80=99 [-Werror=3Dunused-variable]
>> util/trace-event-info.c: In function =E2=80=98read_ftrace_printk=E2=80=99:
>> util/trace-event-info.c:394:21: error: unused variable =E2=80=98check_size=
>> =E2=80=99 [-Werror=3Dunused-variable]
>> cc1: all warnings being treated as errors
>
> Actually, here's an updated patch to fix these..
>
> FYI perf record/annotate/report works fine on my powerpc box here with
> this.  I don't have modules handy so I've not tested that aspect.
>
> Mikey

Thanks for the testing and the cleanup!  You don't really need to test
the modules thing
I just wanted to make sure it worked period on big-endian.

Sonny
