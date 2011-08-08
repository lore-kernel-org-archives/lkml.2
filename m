Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1HHCm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 22:42:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51713 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1HHCm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 22:42:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110802183019.GB8393@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
 <CA+55aFwtyfzaFABHKD+OMWsojGov0JLmnrZimhVaOcrer=tJjQ@mail.gmail.com> <20110802183019.GB8393@windriver.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 7 Aug 2011 22:42:36 -0400
Message-ID: <CAMjpGUcOagn-o_mETLDr-=pa-3sxq_iDjF=A8OGhdJg5+9ewpA@mail.gmail.com>
Subject: Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org, sfr@canb.auug.org.au
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 14:30, Paul Gortmaker wrote:
> [Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage] On 28/07/2011 (Thu 06:19) Linus Torvalds wrote:
>> On Wed, Jul 27, 2011 at 10:16 PM, Paul Gortmaker wrote:
>> > For all 160 commits, the branch "module.h-split", available here:
>> >
>> >        git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git
>> >
>> > has the complete content.  I've put the header changes after all the
>> > patches from the top 5 categories, so that people bisecting non related
>> > issues at a later date don't get hit with a commit zone with build failures.
>>
>> Ok, sounds good. Two questions:
>>
>>  - how much testing (randconfig? different architectures?) has this gotten?
>>
>>  - how much does this actually improve compile times (for a "normal"
>> build or a "allmodconfig" one)?
>>
>> It certainly sounds like the RightThing(tm) to do, but I'd like to
>> know that there is real actual improvements to build times and that
>> the pain won't be too bad...
>
> Now that it has done time in linux-next, let me address the testing
> and (hopefully lack of) pain part.

Blackfin is broken because of this.  a simple grep of the tree
probably could pick this up.  maybe something like:
grep EXPORT_SYMBOL * -rIl | xargs grep -L linux/export.h

from my logs, i see at least:
arch/blackfin/kernel/dma-mapping.c:103: warning: type defaults to
'int' in declaration of 'EXPORT_SYMBOL'
arch/blackfin/kernel/dma-mapping.c:111: warning: type defaults to
'int' in declaration of 'EXPORT_SYMBOL'
arch/blackfin/kernel/dma-mapping.c:121: warning: type defaults to
'int' in declaration of 'EXPORT_SYMBOL'
arch/blackfin/kernel/dma-mapping.c:136: warning: type defaults to
'int' in declaration of 'EXPORT_SYMBOL'
arch/blackfin/kernel/dma-mapping.c:148: warning: type defaults to
'int' in declaration of 'EXPORT_SYMBOL'
arch/blackfin/kernel/sys_bfin.c:50: warning: type defaults to 'int' in
declaration of 'EXPORT_SYMBOL'
arch/blackfin/mach-bf518/boards/ezbrd.c:825: warning: type defaults to
'int' in declaration of 'EXPORT_SYMBOL'
arch/blackfin/mach-bf527/boards/ad7160eval.c:852: warning: type
defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/blackfin/mach-bf527/boards/ezbrd.c:876: warning: type defaults to
'int' in declaration of 'EXPORT_SYMBOL'
arch/blackfin/mach-bf527/boards/ezkit.c:1317: warning: type defaults
to 'int' in declaration of 'EXPORT_SYMBOL'
arch/blackfin/mach-bf527/boards/tll6527m.c:938: warning: type defaults
to 'int' in declaration of 'EXPORT_SYMBOL'
arch/blackfin/mach-bf537/boards/dnp5370.c:396: warning: type defaults
to 'int' in declaration of 'EXPORT_SYMBOL'
arch/blackfin/mm/init.c:22: warning: type defaults to 'int' in
declaration of 'EXPORT_SYMBOL'
arch/blackfin/mm/init.c:32: warning: type defaults to 'int' in
declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:1002: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:107: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:1089: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:124: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:271: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:293: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:353: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:373: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:451: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:515: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:591: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:599: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:610: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:621: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:775: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:786: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:797: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:90: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
sound/soc/blackfin/bf5xx-sport.c:968: warning: type defaults to 'int'
in declaration of 'EXPORT_SYMBOL'
-mike
