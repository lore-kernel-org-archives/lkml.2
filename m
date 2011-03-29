Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab1C2LnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:43:12 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:57112 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab1C2LnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:43:10 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "'Len Brown'" <len.brown@intel.com>, "'Pavel Machek'" <pavel@ucw.cz>,
        "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        <linux-pm@lists.linux-foundation.org>
References: <007801cbead6$1984b6e0$4c8e24a0$@mprc.pku.edu.cn> <201103251439.53568.arnd@arndb.de>
In-Reply-To: <201103251439.53568.arnd@arndb.de>
Subject: RE: Warning with asm-generic/div64.h
Date: Tue, 29 Mar 2011 19:41:56 +0800
Message-ID: <018a01cbee06$534730a0$f9d591e0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQELsns2AiqpHEjTHU0QO/KwN05IOwHV/SC3lbX2F+A=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Friday, March 25, 2011 9:40 PM
> To: Guan Xuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org
> Subject: Re: Warning with asm-generic/div64.h
> 
> On Friday 25 March 2011, Guan Xuetao wrote:
> > Following warning is generated when using <asm-generic/div64.h>
> >
> > kernel/power/hibernate.c: In function 'swsusp_show_speed':
> > kernel/power/hibernate.c:227: warning: comparison of distinct pointer types lacks a cast
> >
> > After expanding the do_div() macro, the problem line is:
> >
> >         (void)(((typeof((n)) *)0) == ((uint64_t *)0));
> >
> > while the type of n is s64.
> >
> > I am puzzled with the usage of the problem line.
> >
> > And how to correct it?
> 
> The purpose of this line is to generate a warning when the input is the
> wrong type, as the comment says:
>  /* The unnecessary pointer compare is there
>   * to check for type safety (n must be 64bit)
Yes, it works. And, I think type s64 should be ok also.

> 
> The macro doesn't work for signed input or for 32 bit input. I'd suggest
> fixing the caller to use an unsigned type.

Then,
Cc: Len Brown <len.brown@intel.com> (supporter:SUSPEND TO RAM)
Cc: Pavel Machek <pavel@ucw.cz> (supporter:SUSPEND TO RAM)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl> (supporter:SUSPEND TO RAM)
Cc: linux-pm@lists.linux-foundation.org (open list:SUSPEND TO RAM)

> 
> 	Arnd
Thanks, and sorry for replying late.

Guan Xuetao

