Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab1KSHwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 02:52:09 -0500
Received: from mail175c2.megamailservers.com ([69.49.111.75]:47708 "EHLO
	mail175c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394Ab1KSHwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 02:52:07 -0500
X-Authenticated-User: konrad.gaisler.com
Message-ID: <4EC76049.8020508@gaisler.com>
Date: Sat, 19 Nov 2011 08:52:41 +0100
From: "konrad.gaisler" <konrad@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        linux kbuild list <linux-kbuild@vger.kernel.org>, mmarek@suse.cz,
        pefoley2@verizon.net, yann.morin.1998@anciens.enib.fr,
        sam@ravnborg.org, zippel@linux-m68k.org
Subject: Re: [PATCH 1/1] kconfig: Add a configuration subtree command to kconfig
References: <1321625774-12749-1-git-send-email-konrad@gaisler.com> <4EC69F65.20207@xenotime.net> <4EC6E179.1030703@gaisler.com> <CACqU3MV=XzNUv70vP7QtQwC2xgqnY0bX+orDA+aErmJGwdEA_w@mail.gmail.com>
In-Reply-To: <CACqU3MV=XzNUv70vP7QtQwC2xgqnY0bX+orDA+aErmJGwdEA_w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=Dt2dKqGHsKqylFsReVPyCOhFPYlE1w6lK6qBgE09yz8= c=1 sm=1
		a=nFJ2T2qeKKUA:10 a=wd-vcygihCUA:10 a=U62ajLuCel8A:10 a=8nJEP1OIZ-IA:10
		a=2wAOqaBLMYbCqLQOYtKPHg==:17 a=ebG-ZW-8AAAA:8 a=VwQbUJbxAAAA:8
		a=W0vUJOdyAAAA:8 a=xvnoFA4Cyc5oH-9BpIQA:9 a=lccjc4dtL_fPJC_pglkA:7
		a=wPNLvfGTeEIA:10 a=xQdB8fRqRzQA:10 a=x8gzFH9gYPwA:10 a=cCYF7-FHeg4A:10
		a=NWVoK91CQyQA:10 a=2wAOqaBLMYbCqLQOYtKPHg==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2011 07:23 AM, Arnaud Lacombe wrote:
> Hi,
>
> On Fri, Nov 18, 2011 at 5:51 PM, konrad.gaisler<konrad@gaisler.com>  wrote:
>> On 11/18/2011 07:09 PM, Randy Dunlap wrote:
>>> (changed linux-config@ to linux-kbuild@vger.kernel.org)
>>>
>>> On 11/18/2011 06:16 AM, Konrad Eisele wrote:
>>>> New kconfig command "subsource":
>>>> subsource "<kconfig>""<cwd>""<.config>""<title>"<internal_prefix>
>>>>   <.config_prefix>
>>>> Allocates<kconfig>    as a configuration subtree using<.config>    as the
>>>> configuration
>>>> file to save and load from.<cwd>    is the directory path to switch to for
>>>> "source" to
>>>> work, "<title>" is the Menu tile of the subtree,<internal_prefix>    is a
>>>> internal prefix,
>>>> and<.config_prefix>    is the prefix to append/remove when
>>>> saving/loading<.config>.
>>> That explains what but not why.  You need some justification(s) for such
>>> a large patch.  Maybe even some example usages.
>> The patch originated from a buildsystem that uses buildroot and linux.
>> Both use Kconfig and the buildsystem itself uses Kconfig. To configure
>> a subproject you have to exit the toplevel Kconfig and restart to
>> startup a subproject Kconfig, It is even more anoying when looking
>> inside buildroot. It has in its turn subprojects uClibc, busybox,
>> linux, crosstools-ng which all use Kconfig. The subtree patch
>> does make it possible to unify all in one Kconfig.
>>
>> As an example, apply the patch, then add to<top>/Kconfig the lines:
>>
>> subsource "arch/sparc/Kconfig" "." ".config_sparc" "SPARC config" SPARC_
>> CONFIG_
>> subsource "arch/mips/Kconfig" "." ".config_mips" "MIPS config" MIPS_ CONFIG_
>>
> ETOOMUCHARGUMENT!
>
> I wonder if we could not get all these parameters specified
> dynamically in the Kconfig. This would replace the `mainmenu' entry
> ala:
>
> config
>      title "Linux ..."
>      prefix "CONFIG_"
>      file .config
> endconfig
Yes maybe it can be done that way. Personally I think it is
more difficult.

>
> That way, everytime you parse a tree, you can generate the structure
> on-the-fly in a non-intrusive manner.
>
> I have been thinking of doing something like that with a config file,
> but doing it in the Kconfig would make much more sense.
>
> Btw, what are you calling "<internal_prefix>" ?

It is a left-over of a previous iteration where I was prefixing all
symbols to avoid namespace clashes. Now I use the symbol->level
field. It can be removed to:

subsource "<kconfig>""<cwd>""<.config>""<title>"<.config_prefix>


-- Konrad

>
> Thanks,
>   - Arnaud
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

