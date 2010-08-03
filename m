Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab0HCNqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:46:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49470 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab0HCNqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:46:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kCeD+8yb2Z4o9FMC6h8lXTze1SMXWqM4loozQxwW7cw70w/06SLuKRoD5Rw9PWFIcS
         bbxSW3pcro28g5Udob62WYN1u/Sy9gT1bfyUpCl1psnFj5y0snffNRUL4iSYAxnfI7jE
         nkV5F000Z9QJ4XHOf1K9yttI5ouiyCEK9FiD8=
MIME-Version: 1.0
In-Reply-To: <4C581CD8.1050606@gmail.com>
References: <1280790966-417-1-git-send-email-justinmattock@gmail.com>
	<4C57E88B.8070505@suse.cz>
	<4C581CD8.1050606@gmail.com>
Date: Tue, 3 Aug 2010 16:46:19 +0300
Message-ID: <AANLkTikPt7-+ThJccOGehERTPS8qBtEtyMB9Ebr2m=PQ@mail.gmail.com>
Subject: Re: [PATCH]scripts/kconfig/nconf.gui.c Fix warning: value computed is 
	not used
From: Nir Tzachar <nir.tzachar@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        zippel@linux-m68k.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/3 Justin P. Mattock <justinmattock@gmail.com>:
> On 08/03/2010 02:59 AM, Michal Marek wrote:
>>
>> On 3.8.2010 01:16, Justin P. Mattock wrote:
>>>
>>> The below patch fixes some warning messages Im getting when doing
>>> make nconfig
>>>
>>>  make nconfig
>>>   HOSTCC  scripts/kconfig/nconf.gui.o
>>> scripts/kconfig/nconf.gui.c: In function 'print_in_middle':
>>> scripts/kconfig/nconf.gui.c:170:2: warning: value computed is not used
>>> scripts/kconfig/nconf.gui.c: In function 'btn_dialog':
>>> scripts/kconfig/nconf.gui.c:300:2: warning: value computed is not used
>>> scripts/kconfig/nconf.gui.c:304:2: warning: value computed is not used
>>> scripts/kconfig/nconf.gui.c: In function 'dialog_inputbox':
>>> scripts/kconfig/nconf.gui.c:395:2: warning: value computed is not used
>>> scripts/kconfig/nconf.gui.c:397:2: warning: value computed is not used
>>> scripts/kconfig/nconf.gui.c:399:2: warning: value computed is not used
>>> scripts/kconfig/nconf.gui.c:404:2: warning: value computed is not used
>>> scripts/kconfig/nconf.gui.c: In function 'show_scroll_win':
>>> scripts/kconfig/nconf.gui.c:534:2: warning: value computed is not used
>>> scripts/kconfig/nconf.gui.c:549:2: warning: value computed is not used
>>> scripts/kconfig/nconf.gui.c:551:2: warning: value computed is not used
>>>   HOSTLD  scripts/kconfig/nconf
>>> scripts/kconfig/nconf arch/x86/Kconfig
>>>
>>> I looked around for a way to fix these, but am not familiar with ncurses.
>>> if there's a better way let me know and/or send a seperate fix.
>>>
>>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>
>>> ---
>>>  scripts/kconfig/nconf.gui.c |   11 -----------
>>>  1 files changed, 0 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
>>> index a9d9344..08a5a04 100644
>>> --- a/scripts/kconfig/nconf.gui.c
>>> +++ b/scripts/kconfig/nconf.gui.c
>>> @@ -167,7 +167,6 @@ void print_in_middle(WINDOW *win,
>>>        length = strlen(string);
>>>        temp = (width - length) / 2;
>>>        x = startx + (int)temp;
>>> -       wattrset(win, color);
>>
>> Huh? :) This change makes nconfig look black and white. I'm all for
>> eliminating warnings, but please do not eliminate features at the same
>> time (or submit a patch with "Subject: make nconfig black and white" and
>> do not mask it as warning fixes).
>>
>> Michal
>>
>
> hmm.. make nconfig is black and white even without this patch, is that
> normal?

No. It should be using colors. Which terminal are you using? Also,
make sure you do not have the wide characters version of ncurses
installed.

> as for the patch not real sure how to handle these(ncurses), but at least
> you know now.. as for masking this with warning fixes.. ouch!! that's a
> first... these are what gcc 4.6 are giving me not the other way around my
> friend.

These warnings are all noise, but should be solved in the last patch I
sent Michal.

Cheers.
