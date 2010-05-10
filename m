Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0EJTUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 15:20:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab0EJTUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 15:20:31 -0400
Message-ID: <4BE85C51.704@redhat.com>
Date: Mon, 10 May 2010 15:19:45 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       Roland McGrath <roland@redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip] perf probe: Don't compile CFI related code if elfutils
 is old
References: <20100510171207.26029.97604.stgit@localhost6.localdomain6> <20100510172854.GD30926@ghostprotocols.net> <20100510183654.GH6450@erda.amd.com> <4BE8571E.4020403@redhat.com> <20100510191501.GC19192@ghostprotocols.net>
In-Reply-To: <20100510191501.GC19192@ghostprotocols.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Mon, May 10, 2010 at 02:57:34PM -0400, Masami Hiramatsu escreveu:
>> Hmm, ok, version.h is also introduced at the same time.
>>
>> # git log ./config/version.h.in
>> commit fbc7245df72ce0142f0a21fa0f4f88c97278bf60
>> Author: Roland McGrath <roland@redhat.com>
>> Date:   Tue Dec 16 17:03:03 2008 -0800
>>
>>     Install elfutils/version.h header for library compatibility checking.
>>
>> So, I think we'd better set NO_DWARF if the elfutils
>> is older than 0.138, since we can't check API compatibility
>> easily.
> 
> Well, for that you can just add some of the code you ifdefed in this
> patch into the tools/perf/Makefile test, or better, duplicate the test,
> including just the CPI stuff in the new test, and then set NO_DWARF_CFI
> and use it as the ifdef condition :-)

Hm, I'd like to add just '#ifndef _ELFUTILS_PREREQ;#error;#endif' to
NO_DWARF checking in Makefile, because it's easier to expand to another
API dependency.

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
