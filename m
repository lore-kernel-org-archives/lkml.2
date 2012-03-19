Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031189Ab2CSRoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:44:08 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.101]:48742 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab2CSRoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:44:06 -0400
Message-ID: <4F677074.90906@bwalle.de>
Date: Mon, 19 Mar 2012 18:44:20 +0100
From: Bernhard Walle <bernhard@bwalle.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120313 Thunderbird/11.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kbuild.devel,gmane.linux.kernel
To: Sam Ravnborg <sam@ravnborg.org>
CC: mmarek@suse.cz, lacombar@gmail.com, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>, zippel@linux-m68k.org
Subject: Re: [PATCH] scripts/Kbuild.include: Fix portability problem of "echo
 -e"
References: <1330277718-2667-1-git-send-email-bernhard@bwalle.de> <20120226174805.GA562@merkur.ravnborg.org> <4F4A7126.6020009@bwalle.de> <20120226210551.GA659@merkur.ravnborg.org>
In-Reply-To: <20120226210551.GA659@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: YmVybmhhcmRAYndhbGxlLmRl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.02.12 22:05, schrieb Sam Ravnborg:
> On Sun, Feb 26, 2012 at 06:51:34PM +0100, Bernhard Walle wrote:
>> Am 26.02.12 18:48, schrieb Sam Ravnborg:
>>>>> --- a/scripts/Kbuild.include
>>>>> +++ b/scripts/Kbuild.include
>>>>> @@ -104,7 +104,7 @@ as-option = $(call try-run,\
>>>>>  # Usage: cflags-y += $(call as-instr,instr,option1,option2)
>>>>>  
>>>>>  as-instr = $(call try-run,\
>>>>> -	/bin/echo -e "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
>>>>> +	printf "%b\n" "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
>>>>>  
>>>>>  # cc-option
>>>>>  # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
>>> Roman Zippel removed use of printf in this patch: beda9f3a13bbb22cde92a45f230a02ef2afef6a9
>>>
>>> I cannot remember why - but it would be good if you could dig up
>>> why - just so we do not hit an old issue again.
>>
>> Well, he used printf "$(1)", that's different from printf "%b\n" "$(1)"
>> since format strings inside $(1) would be interpreted.
> Makes good sense.

Can we merge that for 3.4? Who is responsible, i.e. whose tree?


Regards,
Bernhard

