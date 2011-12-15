Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129Ab1LOQnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:43:37 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:47743 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751798Ab1LOQng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:43:36 -0500
Message-ID: <4EEA31CB.7070205@xenotime.net>
Date: Thu, 15 Dec 2011 09:43:39 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Tony Breeds <tony@bakeyournoodle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next bad Kconfig for drivers/hid
References: <20111209012746.GC20353@thor.bakeyournoodle.com> <4EE19DA0.5010705@goop.org> <alpine.LNX.2.00.1112120020330.21970@pobox.suse.cz> <20111212003140.GA16353@thor.bakeyournoodle.com> <alpine.LNX.2.00.1112151107020.21970@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1112151107020.21970@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 02:08 AM, Jiri Kosina wrote:
> On Mon, 12 Dec 2011, Tony Breeds wrote:
> 
>> On Mon, Dec 12, 2011 at 12:21:16AM +0100, Jiri Kosina wrote:
>>> On Thu, 8 Dec 2011, Jeremy Fitzhardinge wrote:
>>>>
>>>> Hm.  How about making it "depends on HID && POWER_SUPPLY"?  I think that
>>>> would needlessly disable it if HID is also modular, but I'm not sure how
>>>> to fix that.  "depends on HID && POWER_SUPPLY && HID == POWER_SUPPLY"?
>>
>> That would work, but I think technically I think you could end up with
>> HID=m and POWER_SUPPLY=m which would still allow HID_BATTERY_STRENGTH=y
>> which is the same problem.
>>
>> I don't know what kind of .config contortions you'd need to do to get
>> there.
>>  
>>> How about making it 'default POWER_SUPPLY' instead?
>>
>> By itself that wont help as POWER_SUPPLY=m statisfies.
>>
>> So it looks like we have Jeremy's:
>> 	HID && POWER_SUPPLY && HID == POWER_SUPPLY
> 
> Tony,
> 
> have you actually tested this one to work in the configuration you have 
> been seeing it to fail?
> 
> I don't seem to be able to find any use of '==' in other Kconfig files 
> (and never used it myself), so I'd like to have confirmation that it 
> actually works and fixes the problem before I apply it :)

Documentation/kbuild/kconfig-language.txt does not list "==":

<expr> ::= <symbol>                             (1)
           <symbol> '=' <symbol>                (2)
           <symbol> '!=' <symbol>               (3)
           '(' <expr> ')'                       (4)
           '!' <expr>                           (5)
           <expr> '&&' <expr>                   (6)
           <expr> '||' <expr>                   (7)


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
