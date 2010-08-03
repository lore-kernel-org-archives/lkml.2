Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab0HCOcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:32:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62466 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab0HCOcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:32:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HJLBvBcQ02JpdEfUkDk2S4VYjgjPgrkH0e4Q9jz4QSFS6VU+/tO1PUWPhi7eRljRKP
         swHZKAoxea1f58rOA0xwUa+MGlr9iye+4itO0DAJVqZf0Ql1khUpwN1rqKO0q7Pmdo0/
         gn8EY+Ey0vOFsRsZHh1IK/ULAEgcfKwaZPy+w=
Message-ID: <4C582883.6090203@gmail.com>
Date: Tue, 03 Aug 2010 07:32:35 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Nir Tzachar <nir.tzachar@gmail.com>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        zippel@linux-m68k.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]scripts/kconfig/nconf.gui.c Fix warning: value computed
 is 	not used
References: <1280790966-417-1-git-send-email-justinmattock@gmail.com>	<4C57E88B.8070505@suse.cz>	<4C581CD8.1050606@gmail.com> <AANLkTikPt7-+ThJccOGehERTPS8qBtEtyMB9Ebr2m=PQ@mail.gmail.com>
In-Reply-To: <AANLkTikPt7-+ThJccOGehERTPS8qBtEtyMB9Ebr2m=PQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 06:46 AM, Nir Tzachar wrote:
> 2010/8/3 Justin P. Mattock<justinmattock@gmail.com>:
>> On 08/03/2010 02:59 AM, Michal Marek wrote:
>>>
>>> On 3.8.2010 01:16, Justin P. Mattock wrote:
>>>>
>>>> The below patch fixes some warning messages Im getting when doing
>>>> make nconfig
>>>>
>>>>   make nconfig
>>>>    HOSTCC  scripts/kconfig/nconf.gui.o
>>>> scripts/kconfig/nconf.gui.c: In function 'print_in_middle':
>>>> scripts/kconfig/nconf.gui.c:170:2: warning: value computed is not used
>>>> scripts/kconfig/nconf.gui.c: In function 'btn_dialog':
>>>> scripts/kconfig/nconf.gui.c:300:2: warning: value computed is not used
>>>> scripts/kconfig/nconf.gui.c:304:2: warning: value computed is not used
>>>> scripts/kconfig/nconf.gui.c: In function 'dialog_inputbox':
>>>> scripts/kconfig/nconf.gui.c:395:2: warning: value computed is not used
>>>> scripts/kconfig/nconf.gui.c:397:2: warning: value computed is not used
>>>> scripts/kconfig/nconf.gui.c:399:2: warning: value computed is not used
>>>> scripts/kconfig/nconf.gui.c:404:2: warning: value computed is not used
>>>> scripts/kconfig/nconf.gui.c: In function 'show_scroll_win':
>>>> scripts/kconfig/nconf.gui.c:534:2: warning: value computed is not used
>>>> scripts/kconfig/nconf.gui.c:549:2: warning: value computed is not used
>>>> scripts/kconfig/nconf.gui.c:551:2: warning: value computed is not used
>>>>    HOSTLD  scripts/kconfig/nconf
>>>> scripts/kconfig/nconf arch/x86/Kconfig
>>>>
>>>> I looked around for a way to fix these, but am not familiar with ncurses.
>>>> if there's a better way let me know and/or send a seperate fix.
>>>>
>>>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>>
>>>> ---
>>>>   scripts/kconfig/nconf.gui.c |   11 -----------
>>>>   1 files changed, 0 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
>>>> index a9d9344..08a5a04 100644
>>>> --- a/scripts/kconfig/nconf.gui.c
>>>> +++ b/scripts/kconfig/nconf.gui.c
>>>> @@ -167,7 +167,6 @@ void print_in_middle(WINDOW *win,
>>>>         length = strlen(string);
>>>>         temp = (width - length) / 2;
>>>>         x = startx + (int)temp;
>>>> -       wattrset(win, color);
>>>
>>> Huh? :) This change makes nconfig look black and white. I'm all for
>>> eliminating warnings, but please do not eliminate features at the same
>>> time (or submit a patch with "Subject: make nconfig black and white" and
>>> do not mask it as warning fixes).
>>>
>>> Michal
>>>
>>
>> hmm.. make nconfig is black and white even without this patch, is that
>> normal?
>
> No. It should be using colors. Which terminal are you using? Also,
> make sure you do not have the wide characters version of ncurses
> installed.

Im using xterm.. ncurses was built with --enable-widec on both machines 
which probably explains why the whole black and white look.

>
>> as for the patch not real sure how to handle these(ncurses), but at least
>> you know now.. as for masking this with warning fixes.. ouch!! that's a
>> first... these are what gcc 4.6 are giving me not the other way around my
>> friend.
>
> These warnings are all noise, but should be solved in the last patch I
> sent Michal.
>
> Cheers.
>

cool..

Justin P. Mattock
