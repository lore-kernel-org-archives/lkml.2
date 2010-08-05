Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995Ab0HESTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:19:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46359 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab0HESTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:19:30 -0400
Message-ID: <4C5B00A2.5020802@oracle.com>
Date: Thu, 05 Aug 2010 11:19:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Nir Tzachar <nir.tzachar@gmail.com>
CC: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        sam@ravnborg.org
Subject: Re: [PATCH] nconfig: add search support
References: <AANLkTimyDwWtLbc682rW-QORjU0+r+txZO-iKAini1H1@mail.gmail.com>	<1280838492-9942-1-git-send-email-nir.tzachar@gmail.com>	<20100805100408.5b724047.randy.dunlap@oracle.com> <AANLkTi=9hBYy4k=tJBo38O98z_O646ZpStqNdEYWP3MO@mail.gmail.com>
In-Reply-To: <AANLkTi=9hBYy4k=tJBo38O98z_O646ZpStqNdEYWP3MO@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C5B00A9.0219:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/10 11:13, Nir Tzachar wrote:
> On Thu, Aug 5, 2010 at 8:04 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On Tue,  3 Aug 2010 15:28:12 +0300 nir.tzachar@gmail.com wrote:
>>
>>> From: Nir Tzachar <nir.tzachar@gmail.com>
>>>
>>> Remove the old hotkeys feature, and replace by a regular string search.
>>> Behaviour of search is as advised by Sam.
>>>
>>> From nconfig help:
>>>
>>> Searching: pressing '/' triggers search mode. nconfig performs a
>>>            regular string compare, case insensitive, starting at
>>
>> I would say: simple string compare
>> "regular" has no meaning (at least for me) there.
> 
> Regular means strcasecmp...

That's not meaningful to a non-developer user.
I'm a developer and it still has little meaning to me in this context.


>>>            the beginning of each menu line.\n"
>>>            Pressing the up/down keys highlights the previous/next
>>>            matching item. Backspace removes one character from the
>>>            match string. Pressing either '/' again or ESC exits\
>>>            search mode. All other keys behave normally.
>>>
>>> Miscellaneous other changes (including Rundy's Justin's input).
>>
>> Yes, the bottom menu and the typos are fixed.  Thanks.
>>
>> However, I'm not finding this terribly useful, mostly due to it starting
>> comparison at the beginning of each menu line.
>>
>> E.g., I'd like to be able to find "emulations" in the top-level menu here:
>>        Executable file formats / Emulations  --->
>> or I'd like to be able to find "crc" menu items in any sub-menu.
>> Maybe I should just stick to config symbol searches.  I don't think it's all
>> that likely that people will know how each menu line text begins.
>>
>>
> 
> We can replace strcasecmp with strcasestr. I agree it would be more useful.

Yes.

>> As for the search UI, I'd rather that it be presented like the symbol search,
>> in a box, instead of just a single line at the top of the screen.
> 
> But then it is not interactive. I was aiming for something similar to
> vim's search, where the search is matched as you type and the only
> free terminal real-estate to display the match string was at the top
> of the screen. I think such a minimal design is better than a
> cumbersome text box which displays the search results afterwards (as
> is symbol search), as the search is only intended for the currently
> displayed menu and the user would usually just want to save the extra
> typing of navigating to a specific menu item.

OK, I expect that I'll just mostly use symbol search instead of this one then.

The kicker for me is not how/where the dialog is -- it's this comment:

  "as the search is only intended for the currently displayed menu"

I think that's much too limiting.


> Cheers.
> 
>>> Signed-off-by: Nir Tzachar <nir.tzachar@gmail.com>
>>> ---
>>>  scripts/kconfig/nconf.c     |  350 +++++++++++++++++++++++++------------------
>>>  scripts/kconfig/nconf.gui.c |   20 ++--
>>>  scripts/kconfig/nconf.h     |    3 +-
>>>  3 files changed, 213 insertions(+), 160 deletions(-)


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
