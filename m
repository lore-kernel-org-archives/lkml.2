Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab0EaTmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:42:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14606 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab0EaTmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:42:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=wupezX5xbxcRSwmjL5/cBYDBOlddiq20en5jeskrPQ6LiJTXjsHK9GmBtPYGRoWbB
	Cqr1k1m2aQMRc9ghR9pFw==
MIME-Version: 1.0
In-Reply-To: <52092.1275333099@localhost>
References: <1274234900-12162-1-git-send-email-acme@infradead.org>
	<1274234900-12162-2-git-send-email-acme@infradead.org>
	<52092.1275333099@localhost>
Date: Mon, 31 May 2010 21:30:36 +0200
Message-ID: <AANLkTimBxG-2TVC7hAfvRHWupa8T7FaVEcDTnAMCtQWy@mail.gmail.com>
Subject: Re: [PATCH 1/5] perf stat: add perf stat -B to pretty print large 
	numbers
From: Stephane Eranian <eranian@google.com>
To: Valdis.Kletnieks@vt.edu
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4VJgVim011272

On Mon, May 31, 2010 at 9:11 PM,  <Valdis.Kletnieks@vt.edu> wrote:> On Tue, 18 May 2010 23:08:16 -0300, Arnaldo Carvalho de Melo said:>> (Sorry for late reply)>>> instance LC_NUMERIC=en_US.UTF8. You need to pass -B to activate this>> feature. This way existing scripts parsing the output do not need to be>> changed. Here is an example.>>>> $ perf stat noploop 2>> noploop for 2 seconds>>>>  Performance counter stats for 'noploop 2':>>>>         1998.347031  task-clock-msecs         #      0.998 CPUs>>                  61  context-switches         #      0.000 M/sec>>                   0  CPU-migrations           #      0.000 M/sec>>                 118  page-faults              #      0.000 M/sec>>       4,138,410,900  cycles                   #   2070.917 M/sec  (scaled from 70.01%)>>       2,062,650,268  instructions             #      0.498 IPC    (scaled from 70.01%)>>       2,057,653,466  branches                 #   1029.678 M/sec  (scaled from 70.01%)>>              40,267  branch-misses            #      0.002 %      (scaled from 30.04%)>>       2,055,961,348  cache-references         #   1028.831 M/sec  (scaled from 30.03%)>>              53,725  cache-misses             #      0.027 M/sec  (scaled from 30.02%)>>>>         2.001393933  seconds time elapsed>>>> $ perf stat -B  noploop 2>> noploop for 2 seconds>>>>  Performance counter stats for 'noploop 2':>>>>         1998.297883  task-clock-msecs         #      0.998 CPUs>>                  59  context-switches         #      0.000 M/sec>>                   0  CPU-migrations           #      0.000 M/sec>>                 119  page-faults              #      0.000 M/sec>>       4,131,380,160  cycles                   #   2067.450 M/sec  (scaled from 70.01%)>>       2,059,096,507  instructions             #      0.498 IPC    (scaled from 70.01%)>>       2,054,681,303  branches                 #   1028.216 M/sec  (scaled from 70.01%)>>              25,650  branch-misses            #      0.001 %      (scaled from 30.05%)>>       2,056,283,014  cache-references         #   1029.017 M/sec  (scaled from 30.03%)>>              47,097  cache-misses             #      0.024 M/sec  (scaled from 30.02%)>>>>         2.001391016  seconds time elapsed>> Is it me, or did -B not make any difference for these two examples?> I'm confused.>Did you set the LC_NUMERIC environement variable?
>> -     fprintf(stderr, " %14.6f  %-24s", msecs, event_name(counter));>> +     fprintf(stderr, " %18.6f  %-24s", msecs, event_name(counter));>>> -     fprintf(stderr, " %14.0f  %-24s", avg, event_name(counter));>> +     if (big_num)>> +             fprintf(stderr, " %'18.0f  %-24s", avg, event_name(counter));>> +     else>> +             fprintf(stderr, " %18.0f  %-24s", avg, event_name(counter));>>> -             fprintf(stderr, " %14s  %-24s\n",>> +             fprintf(stderr, " %18s  %-24s\n",>>                       "<not counted>", event_name(counter));>>> -     fprintf(stderr, " %14.9f  seconds time elapsed",>> +     fprintf(stderr, " %18.9f  seconds time elapsed",>> Why is the 'if (big_num)' applied to only one of the 4 sites, and the> other 3 blindly expanded from 14 to 18 characters?
Because the units of the others don't make sense.The expansion is to make things still appear aligned when the thousandsare separated.
>


-- Stephane Eranian  | EMEA Software EngineeringGoogle France | 38 avenue de l'Opéra | 75002 ParisTel : +33 (0) 1 42 68 53 00This email may be confidential or privileged. If you received thiscommunication by mistake, pleasedon't forward it to anyone else, please erase all copies andattachments, and please let me know thatit went to the wrong person. Thanks���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
