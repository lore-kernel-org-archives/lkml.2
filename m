Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab2C1LUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:20:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63288 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab2C1LUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:20:11 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: roma1390 <roma1390@gmail.com>
Subject: Re: [PATCH 0/1] vsprintf: optimize decimal conversion (again)
Date: Wed, 28 Mar 2012 13:20:07 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
References: <201203262047.17865.vda.linux@googlemail.com> <201203281233.42914.vda.linux@googlemail.com> <4F72EA68.9090605@gmail.com>
In-Reply-To: <4F72EA68.9090605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201203281320.07765.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2012 12:39, roma1390 wrote:
> On 2012.03.28 13:33, Denys Vlasenko wrote:
> > On Wednesday 28 March 2012 12:24, roma1390 wrote:
> >> On 2012.03.28 13:13, Denys Vlasenko wrote:
> >>> Second: run
> >>> arm-linux-gnueabi-gcc -O2 -Wall test_{org,new}.c -S
> >>> and email me resulting test_{org,new}.s files.
> >>
> >> test_{org,new}.s attached.
> >
> >
> > Bingo.
> >
> >          bl      __aeabi_uidivmod
> >
> > Not good. Your gcc did not optimize division by constant.
> >
> > Can you add  "noinline_for_stack":
> >
> > static noinline_for_stack<=== HERE
> > char *put_dec(char *buf, unsigned long long n)
> >
> > amd regenerate and resend the test_new.s?
> >
> 
> Hello,
> 
> Your requested asm are attached.

Asm looks good: there are only three long multiplies in the
put_dec + put_dec_full4, and no divisions at all.

Please speed-test this version.

-- 
vda
