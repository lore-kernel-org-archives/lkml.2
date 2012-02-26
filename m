Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2BZRw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 12:52:57 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:35973 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2BZRw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 12:52:56 -0500
Message-ID: <4F4A7126.6020009@bwalle.de>
Date: Sun, 26 Feb 2012 18:51:34 +0100
From: Bernhard Walle <bernhard@bwalle.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: mmarek@suse.cz, lacombar@gmail.com, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>, zippel@linux-m68k.org
Subject: Re: [PATCH] scripts/Kbuild.include: Fix portability problem of "echo
 -e"
References: <1330277718-2667-1-git-send-email-bernhard@bwalle.de> <20120226174805.GA562@merkur.ravnborg.org>
In-Reply-To: <20120226174805.GA562@merkur.ravnborg.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: YmVybmhhcmRAYndhbGxlLmRl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.02.12 18:48, schrieb Sam Ravnborg:
>> > --- a/scripts/Kbuild.include
>> > +++ b/scripts/Kbuild.include
>> > @@ -104,7 +104,7 @@ as-option = $(call try-run,\
>> >  # Usage: cflags-y += $(call as-instr,instr,option1,option2)
>> >  
>> >  as-instr = $(call try-run,\
>> > -	/bin/echo -e "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
>> > +	printf "%b\n" "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
>> >  
>> >  # cc-option
>> >  # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
> Roman Zippel removed use of printf in this patch: beda9f3a13bbb22cde92a45f230a02ef2afef6a9
> 
> I cannot remember why - but it would be good if you could dig up
> why - just so we do not hit an old issue again.

Well, he used printf "$(1)", that's different from printf "%b\n" "$(1)"
since format strings inside $(1) would be interpreted.

But maybe Roman can comment on that? Cc'ing him.


Regards,
Bernhard



