Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2ECMCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:02:48 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61036 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751356Ab2ECMCr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:02:47 -0400
MIME-Version: 1.0
In-Reply-To: <1335995781.30754.27.camel@x61.thuisdomein>
References: <CADDKRnDR=baZtQfyQLxYGB2zVDMGi2C_V2ffNkSUhipJB-+t=A@mail.gmail.com>
	<1335995781.30754.27.camel@x61.thuisdomein>
Date: Thu, 3 May 2012 14:02:45 +0200
Message-ID: <CADDKRnA7XMczevE2JRsMR508mdz+Rgs+QvV4QCMqnts8t+1y3A@mail.gmail.com>
Subject: Re: [v3.4-rc5]: drm references experimental
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,

> I also noticed that there's not a single instance of CONFIG_EXPERIMENTAL
> in any code-file or in any Makefile. EXPERIMENTAL is only relevant in,
> well, Kconfig space.

this means especially the following is not possible or does not occure:

NON-EXP:
driver "A" uses library function "B"

EXP:
unchanged driver "A" now uses EXPERIMENTAL function "B-EXP"

The question is whether this is guaranteed.

Thanks,Jörg


2012/5/2 Paul Bolle <pebolle@tiscali.nl>:
> On Mon, 2012-04-30 at 16:31 +0200, Jörg Otte wrote:
>> there is a dependency between drm and experimental driver. If I
>> don't enable EXPERIMENTAL I see the following during configuration:
>>
>> warning: (DRM) selects DMA_SHARED_BUFFER which has unmet direct
>> dependencies (EXPERIMENTAL)
>>
>> I think non-experimental code shouldn't depend on experimental code.
>
> This reminds me of a brief discussion on the merits of EXPERIMENTAL
> starting at https://lkml.org/lkml/2012/1/18/385 . My impression from
> that discussion was that EXPERIMENTAL currently is set in most
> configurations (eg, even Debian stable has EXPERIMENTAL set). This means
> that people generally won't notice that an option that itself doesn't
> depend (indirectly) on EXPERIMENTAL selects an option that does depend
> directly on EXPERIMENTAL. So, yes, one wouldn't expect non-EXPERIMENTAL
> code to use EXPERIMENTAL code but, apparently, in practice it does.
>
> I also noticed that there's not a single instance of CONFIG_EXPERIMENTAL
> in any code-file or in any Makefile. EXPERIMENTAL is only relevant in,
> well, Kconfig space. That should make it somewhat less likely that there
> are surprising changes to the code than in other cases of options
> selecting options with unmet direct dependencies.
>
>
> Paul Bolle
>
