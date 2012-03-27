Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab2C0HTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:19:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab2C0HTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:19:02 -0400
MIME-Version: 1.0
In-Reply-To: <4F711EC0.3080708@am.sony.com>
References: <CACqU3MUXAOMGQ1nzUrtYPEQAC3U-nuq3YurtNJJLS1hft4ROGA@mail.gmail.com>
	<1310626276-4541-1-git-send-email-abogani@kernel.org>
	<4F6D2BC5.9070200@am.sony.com>
	<4F711EC0.3080708@am.sony.com>
Date: Tue, 27 Mar 2012 09:19:00 +0200
X-Google-Sender-Auth: ZbmxNyaf-4j_ZK8E5n-TRumCh-s
Message-ID: <CAPk1OjELnXiZVreaEh94e3RT306mmkQxxyg2DH5aYy=rQ9yr1w@mail.gmail.com>
Subject: Re: [PATCH] modpost: Fix modpost's license checking V3
From: Alessio Igor Bogani <abogani@kernel.org>
To: frank.rowand@am.sony.com
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jan Beulich <jbeulich@novell.com>,
        Kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Bird, Tim" <Tim.Bird@am.sony.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Arnaud Lacombe <lacombar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Rowand,

Il 27 marzo 2012 03:58, Frank Rowand <frank.rowand@am.sony.com> ha scritto:
> On 03/23/12 19:04, Frank Rowand wrote:
>> On 07/13/11 23:51, Alessio Igor Bogani wrote:
>>> The commit f02e8a6 sorts symbols placing each of them in its own elf section.
>>> The sorting and merging into the canonical sections are done by the linker.
>>> Unfortunately modpost to generate Module.symvers file parses vmlinux
>>
>> Yet another unfortunately: modpost parses vmlinux.o instead of vmlinux (vmlinux
>> does not yet exist at this point of the build).  vmlinux.o also does not have
>> the many sections sorted and merged into the canonical sections.  As a result,
>> the Module.symvers created my modpost incorrectly reports the license of all
>> exports as "(unknown)".
>>
>> Can you fix this also please?
>
> The attached patch modifies your patch to also use export_from_secname()
> for vmlinux and vmlinux.o.
>
> This is a rather blind shot at fixing the problem, so please review
> carefully.  After applying the patch, Module.symvers reports the license
> correctly for exports from vmlinux.o.

Could you show me how reproduce that problem? Indeed on my system
"unknown" is reported (erroneously) in the v3.0 series before the
commit 62a2635610dbc83c5e8d724e00941eee4d18c186 (and obviously after
my patchset which adds that bug).

Thanks!

Ciao,
Alessio
