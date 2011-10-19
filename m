Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1JSCXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 22:23:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:65326 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab1JSCXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 22:23:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,368,1315206000"; 
   d="scan'208";a="79482674"
From: "Xu, Anhua" <anhua.xu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 19 Oct 2011 10:23:12 +0800
Subject: RE: perf tools: interface for improved PEBS ABI can accept wrong
 parameter
Thread-Topic: perf tools: interface for improved PEBS ABI can accept wrong
 parameter
Thread-Index: AcyNw8bcUbdWK6zOSxm4WLVPC5TYCgAQPqrQ
Message-ID: <1A42CE6F5F474C41B63392A5F80372B212DC9365C1@shsmsx501.ccr.corp.intel.com>
References: <1A42CE6F5F474C41B63392A5F80372B212DC93638A@shsmsx501.ccr.corp.intel.com>
	 <20111018181943.GC21666@elte.hu> <1318962501.14880.6.camel@twins>
In-Reply-To: <1318962501.14880.6.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9J2O1vq010891

Thanks Peter:). The key point for this is that the detailed information about "PRECISE_IP" may not be exposed to user space.
Error reporting may come from syscall. Anyway, expect acme's suggestions.


-----Original Message-----
From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl] 
Sent: Wednesday, October 19, 2011 2:28 AM
To: Ingo Molnar
Cc: Xu, Anhua; Arnaldo Carvalho de Melo; linux-kernel@vger.kernel.org
Subject: Re: perf tools: interface for improved PEBS ABI can accept wrong parameter

On Tue, 2011-10-18 at 20:19 +0200, Ingo Molnar wrote:
> > +#define SAMPLE_IP_MAX        3 
> >                               precise_ip     :  2, /* skid constraint       */
> >                               mmap_data      :  1, /* non-exec mmap data    */
> >                               sample_id_all  :  1, /* sample_type all events */
> > diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> > index 928918b..a2068cc 100644
> > --- a/tools/perf/util/parse-events.c
> > +++ b/tools/perf/util/parse-events.c
> > @@ -775,7 +775,10 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
> >       attr->exclude_user   = eu;
> >       attr->exclude_kernel = ek;
> >       attr->exclude_hv     = eh;
> > -     attr->precise_ip     = precise;
> > +     if ( precise < SAMPLE_IP_MAX )
> > +             attr->precise_ip = precise;
> > +     else
> > +             return -1; 

That name is horrid, how about PRECISE_IP_MAX? Also, I suspect acme will
want a better error return than -1, but I'll leave that up to him.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
