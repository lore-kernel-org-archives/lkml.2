Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0JVFbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 01:31:31 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46300 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab0JVFba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 01:31:30 -0400
X-AuditID: b753bd60-a98ddba000000a18-ae-4cc121afe096
Message-ID: <4CC121AD.7070105@hitachi.com>
Date: Fri, 22 Oct 2010 14:31:25 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip  6/7] perf probe: Show accessible global variables
References: <20101021101243.3542.28282.stgit@ltc236.sdl.hitachi.co.jp> <20101021101335.3542.31003.stgit@ltc236.sdl.hitachi.co.jp> <20101021205051.GK3826@ghostprotocols.net> <4CC0F61F.8000501@hitachi.com>
In-Reply-To: <4CC0F61F.8000501@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/10/22 11:25), Masami Hiramatsu wrote:
> (2010/10/22 5:50), Arnaldo Carvalho de Melo wrote:
>> Em Thu, Oct 21, 2010 at 07:13:35PM +0900, Masami Hiramatsu escreveu:
>>> Add --externs for allowing --vars to show accessible
>>> global(externally defined) variables from a given probe
>>> point too.
>>> This will give you a hint which globals can be accessible
>>> from the probe point.
>>
>> Cool, but perhaps we need to filter out some of the globals? Things
>> like:
> 
> Hmm, yeah. So is that enough to filter out symbols which start with
> __k???tab_ and __crc_ ?
> 
> 
>>
>>                 long unsigned int       __kcrctab_tcp_hashinfo
>>                 long unsigned int       __kcrctab_tcp_proc_register
>>                 long unsigned int       __kcrctab_tcp_proc_unregister
>>                 long unsigned int       __kcrctab_tcp_prot

BTW, with my kernel (yesterday -tip/x86-64/gcc-4.4.4-10),
perf probe doesn't find these __k???tab_ symbols in
dwarf. (but those are still in /proc/kallsyms)
Maybe, something has been changed or it depends on some
config/environment.

Thank you,


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
