Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab1LBTXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:23:34 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45851 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab1LBTXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:23:33 -0500
MIME-Version: 1.0
In-Reply-To: <20111202072800.GC14515@moon>
References: <20111129191252.769160532@openvz.org>
	<20111129191638.756761754@openvz.org>
	<20111129200627.GO5169@outflux.net>
	<20111202002405.GA7701@p183.telecom.by>
	<20111202072800.GC14515@moon>
Date: Fri, 2 Dec 2011 11:23:32 -0800
X-Google-Sender-Auth: BsA2-PAxj0_48ZQ27yPGVjcQlc4
Message-ID: <CAGXu5jLSuvFnV5er6A5abg6EMWM6XVZmVaOCRjwTMS+p4oEXAQ@mail.gmail.com>
Subject: Re: [rfc 1/3] fs, proc: Add start_data, end_data, start_brk members
 to /proc/$pid/stat
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 11:28 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Fri, Dec 02, 2011 at 03:24:06AM +0300, Alexey Dobriyan wrote:
>> > > +         cputime_to_clock_t(cgtime),
>> > > +         mm ? (permitted ? mm->start_data : 1) : 0,
>> > > +         mm ? (permitted ? mm->end_data : 1) : 0,
>> > > +         mm ? (permitted ? mm->start_brk : 1) : 0);
>> > >   if (mm)
>> > >           mmput(mm);
>> > >   return 0;
>> >
>> > Thanks for using "permitted" here. :)
>>
>> And these are new fields, so "1" hack is unnecessary.
>
> I perhaps miss some history here, you mean just print 0
> instead of 1, right?

The history is that when "0" is seen for start_code, tools like "ps"
assumed the process was a kernel thread, so "1" was used as a hack to
not break userspace reporting. So yeah, since this is a new field,
it's fine to just do:

+         (mm && permitted) ? mm->start_data : 0,
+         (mm && permitted) ? mm->end_data : 0,
+         (mm && permitted) ? mm->start_brk : 0,

-Kees

-- 
Kees Cook
ChromeOS Security
