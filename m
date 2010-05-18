Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0ERJkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 05:40:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26675 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab0ERJkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 05:40:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=I4OH2cRL6xnd7S6WteX7Y6SDKG4ulRCX0WUQT5Ftsp0D6F6VtVhtKO22Di81H1xT+
	+CvTidLuGG++e8JD7/x6Q==
MIME-Version: 1.0
In-Reply-To: <20100518093535.GF21799@erda.amd.com>
References: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
	 <tip-7752f1b096e13991f20b59fd11ba73da3809d93c@git.kernel.org>
	 <20100518093535.GF21799@erda.amd.com>
Date: Tue, 18 May 2010 11:39:58 +0200
Message-ID: <AANLkTilWR9fEWBOZLyvFcU6DR6i9aswpSRzFnlIiSoNm@mail.gmail.com>
Subject: Re: [tip:perf/core] perf probe: Don't compile CFI related code if 
	elfutils is old
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "acme@redhat.com" <acme@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mhiramat@redhat.com" <mhiramat@redhat.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 11:35 AM, Robert Richter <robert.richter@amd.com> wrote:
> On 17.05.10 21:57:38, tip-bot for Masami Hiramatsu wrote:
>> Commit-ID:  7752f1b096e13991f20b59fd11ba73da3809d93c
>> Gitweb:     http://git.kernel.org/tip/7752f1b096e13991f20b59fd11ba73da3809d93c
>> Author:     Masami Hiramatsu <mhiramat@redhat.com>
>> AuthorDate: Mon, 10 May 2010 13:12:07 -0400
>> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
>> CommitDate: Mon, 17 May 2010 22:13:51 -0300
>>
>> perf probe: Don't compile CFI related code if elfutils is old
>>
>> Check elfutils version, and if it is old don't compile CFI analysis code. This
>> allows to compile perf with old elfutils.
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Tested-by: Stephane Eranian <eranian@google.com>
>> Reported-by: Robert Richter <robert.richter@amd.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> LKML-Reference: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>> ---
>
> I think this patch is not needed as we came up with an alternative
> solution with commit:
>
>  6b3c4ef perf probe: Check older elfutils and set NO_DWARF
>
But I am compiling tip, so this patch is in and I still got the problem.
It is because the test program does not check for Dwarf_CFI so it
assumes you have the right version of libdw.

If I understand Masami's patch, you can still compile dwarf support
in despite the lack of Dwarf_CFI.
