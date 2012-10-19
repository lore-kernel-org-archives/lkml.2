Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab2JSP6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:58:55 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:62086 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759300Ab2JSP6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:58:53 -0400
MIME-Version: 1.0
In-Reply-To: <20121019155300.GD980@krava.brq.redhat.com>
References: <1350658326-14715-1-git-send-email-eranian@google.com>
	<1350658326-14715-2-git-send-email-eranian@google.com>
	<1350659619.2768.30.camel@twins>
	<CABPqkBSzwNYHS22xaw2zP0e3QAROSRL0v-K29qxjW1By1iK6pw@mail.gmail.com>
	<20121019152337.GC980@krava.brq.redhat.com>
	<CABPqkBSVn+2OO14Y65n_Z+F3CvLSiF1zztpELJBPzhF3=DANXg@mail.gmail.com>
	<20121019155300.GD980@krava.brq.redhat.com>
Date: Fri, 19 Oct 2012 17:58:52 +0200
Message-ID: <CABPqkBRENynttXj8e80P9eoKN_JNT_xPGqK8+1p+UtoBVd0DRQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf tools: add event modifier to request exclusive
 PMU access
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 5:53 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Fri, Oct 19, 2012 at 05:47:11PM +0200, Stephane Eranian wrote:
>> On Fri, Oct 19, 2012 at 5:23 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>> > On Fri, Oct 19, 2012 at 05:17:57PM +0200, Stephane Eranian wrote:
>> >> On Fri, Oct 19, 2012 at 5:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >> > On Fri, 2012-10-19 at 16:52 +0200, Stephane Eranian wrote:
>> >> >> -modifier_event [ukhpGH]{1,8}
>> >> >> +modifier_event [ukhpGHx]{1,8}
>> >> >
>> >> > wouldn't the max modifier sting length grow by adding another possible
>> >> > modifier?
>> >>
>> >> That's what I thought too, but then I don't understand why it was at
>> >> eight before and not
>> >> seven: One instance of each letter, + a second for pp (precise=2). Or
>> >> am I missing
>> >> something here?
>> >
>> > hm, I think I assumed for some reason that 'ppp' is valid as well
>> >
>> If that's the case, then yes, I need to bump that number to 9.
>
> found my source ;)
>
> include/linux/perf_event.h:
> ...
>
>            /*
>             * precise_ip:
>             *
>             *  0 - SAMPLE_IP can have arbitrary skid
>             *  1 - SAMPLE_IP must have constant skid
>             *  2 - SAMPLE_IP requested to have 0 skid
>             *  3 - SAMPLE_IP must have 0 skid
>             *
>             *  See also PERF_RECORD_MISC_EXACT_IP
>             */
>            precise_ip     :  2, /* skid constraint       */
> ...
>
Ok, nobody supports 3 today, but that's fine. I can change that value to 9 then.
