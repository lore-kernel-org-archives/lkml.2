Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab2JKNqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:46:15 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38243 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab2JKNqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:46:12 -0400
MIME-Version: 1.0
In-Reply-To: <20121011131509.GB16465@sepie.suse.cz>
References: <CAAxaTiOsaHOR4cbwcq=xOn-sWxB6PdB4x_UgYf2rUsPQM=WwWA@mail.gmail.com>
	<20121011131509.GB16465@sepie.suse.cz>
Date: Thu, 11 Oct 2012 15:46:12 +0200
X-Google-Sender-Auth: hlZik3z13OgZisT0xdFSybtp5Lo
Message-ID: <CAAxaTiOYpDZTeWbL2UsL-8FJb4rU4RoZaH-gFScU=khY4+44XQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] Coccicheck: Add the rep+ctxt mode
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: Julia Lawall <julia.lawall@lip6.fr>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 11, 2012 at 3:34 PM, Michal Marek <mmarek@suse.cz> wrote:
> On Thu, Sep 20, 2012 at 10:30:46PM +0200, Nicolas Palix wrote:
>> This adds a 'rep+ctxt' mode which prints the warning
>> message followed by the context.
>>
>> Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
>> ---
>>  scripts/coccicheck | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/scripts/coccicheck b/scripts/coccicheck
>> index 823e972..eb43e40 100755
>> --- a/scripts/coccicheck
>> +++ b/scripts/coccicheck
>> @@ -95,6 +95,9 @@ coccinelle () {
>>       $SPATCH -D report  $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff || \
>>       $SPATCH -D context $FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
>>       $SPATCH -D org     $FLAGS -sp_file $COCCI $OPT $OPTIONS
>> -no_show_diff || exit 1
>
> Your mailer broke this line into two, please try to avoid this next
> time. Also, please CC lkml when submitting patches. I applied the patch
> to kbuild.git#misc now.

Ooops.. Sorry. I didn't notice.

The patches are publish on github in my coccicheck branch.
https://github.com/npalix/linux/commits/coccicheck

Do you prefer a pull request next time to avoid such things ?


Nicolas
>
> Michal
>
>> +    elif [ "$MODE" = "rep+ctxt" ] ; then
>> +     $SPATCH -D report  $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff && \
>> +     $SPATCH -D context $FLAGS -sp_file $COCCI $OPT $OPTIONS
>>  || exit 1
>>      else
>>       $SPATCH -D $MODE   $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
>>      fi
>> --
>> 1.7.11.3



-- 
Nicolas Palix
