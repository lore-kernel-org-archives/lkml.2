Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2IHWUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 18:20:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51592 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab2IHWUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 18:20:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLHCavYZQCOZP0nw0ig9uFx0wbR5UP23zKa0gXvmpFvNDg@mail.gmail.com>
References: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
 <1347065004-15306-4-git-send-email-irina.tirdea@intel.com> <CAOJsxLHCavYZQCOZP0nw0ig9uFx0wbR5UP23zKa0gXvmpFvNDg@mail.gmail.com>
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Sun, 9 Sep 2012 01:19:50 +0300
Message-ID: <CANg8OW+iuqnc-_daWDSXymYNKnr0YEoa_3310YvYJAUF_vCTnQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/12] perf tools: include __WORDSIZE definition
To: Pekka Enberg <penberg@kernel.org>
Cc: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, paulus@samba.org, dsahern@gmail.com,
        namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        Irina Tirdea <irina.tirdea@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +#ifndef __WORDSIZE
>> +#if defined(__x86_64__)
>> +# define __WORDSIZE 64
>> +#endif
>> +#if defined(__i386__) || defined(__arm__)
>> +# define __WORDSIZE 32
>> +#endif
>> +#endif
>
> Why not use "sizeof(unsigned long) * 8" ?

I tried to do it this, but the compilation crashes because this value
is tested in an #if:

target  C: libperf <= tools/perf/util/annotate.c
In file included from tools/perf/util/include/linux/bitmap.h:5:0,
                 from tools/perf/util/header.h:10,
                 from tools/perf/util/session.h:6,
                 from tools/perf/util/build-id.h:4,
                 from tools/perf/util/annotate.c:11:
tools/perf/util/include/linux/bitops.h: In function '__ffs':
tools/perf/util/include/linux/bitops.h:62:5: warning: "sizeof" is not
defined [-Wundef]
tools/perf/util/include/linux/bitops.h:62:5: error: missing binary
operator before token "("

Thanks,
Irina
