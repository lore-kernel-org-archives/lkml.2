Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab0HCQV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:21:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33096 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab0HCQVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iHjZBYJ+IMDuGBhEyPKsWVQEs0xg7P1HopfLm60XGq6TUP0qwh3zEDliWGiu+AwfH8
         Pkly4Zev0VxBrZgNFnF7PAjEwx1CZi6snRY61ZdVEalQ3skqF7mUv0zgBU+xG9sxK4i6
         jQ9JRFBhrwdtkFaL/5D/3nNdADvWxWvoBal6M=
Message-ID: <4C584233.9080404@gmail.com>
Date: Tue, 03 Aug 2010 09:22:11 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Nir Tzachar <nir.tzachar@gmail.com>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        zippel@linux-m68k.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]scripts/kconfig/nconf.gui.c Fix warning: value computed
 is 	not used
References: <1280790966-417-1-git-send-email-justinmattock@gmail.com>	<4C57E88B.8070505@suse.cz>	<4C581CD8.1050606@gmail.com>	<AANLkTikPt7-+ThJccOGehERTPS8qBtEtyMB9Ebr2m=PQ@mail.gmail.com>	<4C582883.6090203@gmail.com> <AANLkTinf9AgQ-mPTmNGzbbkYOH3xbuw_E2pT80YbrUZ4@mail.gmail.com>
In-Reply-To: <AANLkTinf9AgQ-mPTmNGzbbkYOH3xbuw_E2pT80YbrUZ4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 08:54 AM, Nir Tzachar wrote:
> On Tue, Aug 3, 2010 at 5:32 PM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> On 08/03/2010 06:46 AM, Nir Tzachar wrote:
>>>
>>> 2010/8/3 Justin P. Mattock<justinmattock@gmail.com>:
>>>>
>>>> On 08/03/2010 02:59 AM, Michal Marek wrote:
>>>>>
>>>>> On 3.8.2010 01:16, Justin P. Mattock wrote:
>>>>>>
>>>>>> The below patch fixes some warning messages Im getting when doing
>>>>>> make nconfig
>>>>>>
>>>>>>   make nconfig
>>>>>>    HOSTCC  scripts/kconfig/nconf.gui.o
>>>>>> scripts/kconfig/nconf.gui.c: In function 'print_in_middle':
>>>>>> scripts/kconfig/nconf.gui.c:170:2: warning: value computed is not used
>>>>>> scripts/kconfig/nconf.gui.c: In function 'btn_dialog':
>>>>>> scripts/kconfig/nconf.gui.c:300:2: warning: value computed is not used
>>>>>> scripts/kconfig/nconf.gui.c:304:2: warning: value computed is not used
>>>>>> scripts/kconfig/nconf.gui.c: In function 'dialog_inputbox':
>>>>>> scripts/kconfig/nconf.gui.c:395:2: warning: value computed is not used
>>>>>> scripts/kconfig/nconf.gui.c:397:2: warning: value computed is not used
>>>>>> scripts/kconfig/nconf.gui.c:399:2: warning: value computed is not used
>>>>>> scripts/kconfig/nconf.gui.c:404:2: warning: value computed is not used
>>>>>> scripts/kconfig/nconf.gui.c: In function 'show_scroll_win':
>>>>>> scripts/kconfig/nconf.gui.c:534:2: warning: value computed is not used
>>>>>> scripts/kconfig/nconf.gui.c:549:2: warning: value computed is not used
>>>>>> scripts/kconfig/nconf.gui.c:551:2: warning: value computed is not used
>>>>>>    HOSTLD  scripts/kconfig/nconf
>>>>>> scripts/kconfig/nconf arch/x86/Kconfig
>>>>>>
>>>>>> I looked around for a way to fix these, but am not familiar with
>>>>>> ncurses.
>>>>>> if there's a better way let me know and/or send a seperate fix.
>>>>>>
>>>>>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>>>>
>>>>>> ---
>>>>>>   scripts/kconfig/nconf.gui.c |   11 -----------
>>>>>>   1 files changed, 0 insertions(+), 11 deletions(-)
>>>>>>
>>>>>> diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
>>>>>> index a9d9344..08a5a04 100644
>>>>>> --- a/scripts/kconfig/nconf.gui.c
>>>>>> +++ b/scripts/kconfig/nconf.gui.c
>>>>>> @@ -167,7 +167,6 @@ void print_in_middle(WINDOW *win,
>>>>>>         length = strlen(string);
>>>>>>         temp = (width - length) / 2;
>>>>>>         x = startx + (int)temp;
>>>>>> -       wattrset(win, color);
>>>>>
>>>>> Huh? :) This change makes nconfig look black and white. I'm all for
>>>>> eliminating warnings, but please do not eliminate features at the same
>>>>> time (or submit a patch with "Subject: make nconfig black and white" and
>>>>> do not mask it as warning fixes).
>>>>>
>>>>> Michal
>>>>>
>>>>
>>>> hmm.. make nconfig is black and white even without this patch, is that
>>>> normal?
>>>
>>> No. It should be using colors. Which terminal are you using? Also,
>>> make sure you do not have the wide characters version of ncurses
>>> installed.
>>
>> Im using xterm.. ncurses was built with --enable-widec on both machines
>> which probably explains why the whole black and white look.
>
> There is a problem with ncurses compiled with wide characters support.
> We need to make sure nconfig is linked only against the regular
> version, and only the regular headers are used. If you are willing,
> take a look at scripts/kconfig/lxdialog/check-lxdialog.sh and see if
> removing all mentions of ncursesw fixes the problem.
>

I'll have a look and see.

> There might also be a problem if your include files are set up
> incorrectly, that is, /usr/include/ncurses.h is actually from the wide
> version and you are linking against the regular version. I think
> someone mentioned this was a problem on debian.
>
> Cheers.
>
>

ncurses is a bit funky to build i.e. my system is cblfs so I used this 
to build:
http://cross-lfs.org/view/clfs-sysroot/alpha/final-system/ncurses.html

from what I remember I built ncurses normally, then rebuilt with the 
newer libs(*++w.a) or widec etc.. things get a bit confusing with the 
symlinks in there.
(main reason(I think)for doing this at the time is the screen for the 
nvidia drivers gets all messd up without the widec switch turned on)

Anyways I'll have a look and see.

Justin P. Mattock
