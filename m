Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab1KSGXu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 01:23:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60552 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab1KSGXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 01:23:48 -0500
MIME-Version: 1.0
In-Reply-To: <4EC6E179.1030703@gaisler.com>
References: <1321625774-12749-1-git-send-email-konrad@gaisler.com>
	<4EC69F65.20207@xenotime.net>
	<4EC6E179.1030703@gaisler.com>
Date: Sat, 19 Nov 2011 01:23:46 -0500
Message-ID: <CACqU3MV=XzNUv70vP7QtQwC2xgqnY0bX+orDA+aErmJGwdEA_w@mail.gmail.com>
Subject: Re: [PATCH 1/1] kconfig: Add a configuration subtree command to kconfig
From: Arnaud Lacombe <lacombar@gmail.com>
To: "konrad.gaisler" <konrad@gaisler.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        linux kbuild list <linux-kbuild@vger.kernel.org>, mmarek@suse.cz,
        pefoley2@verizon.net, yann.morin.1998@anciens.enib.fr,
        sam@ravnborg.org, zippel@linux-m68k.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 18, 2011 at 5:51 PM, konrad.gaisler <konrad@gaisler.com> wrote:
> On 11/18/2011 07:09 PM, Randy Dunlap wrote:
>>
>> (changed linux-config@ to linux-kbuild@vger.kernel.org)
>>
>> On 11/18/2011 06:16 AM, Konrad Eisele wrote:
>>>
>>> New kconfig command "subsource":
>>> subsource "<kconfig>""<cwd>""<.config>""<title>"<internal_prefix>
>>>  <.config_prefix>
>>> Allocates<kconfig>  as a configuration subtree using<.config>  as the
>>> configuration
>>> file to save and load from.<cwd>  is the directory path to switch to for
>>> "source" to
>>> work, "<title>" is the Menu tile of the subtree,<internal_prefix>  is a
>>> internal prefix,
>>> and<.config_prefix>  is the prefix to append/remove when
>>> saving/loading<.config>.
>>
>> That explains what but not why.  You need some justification(s) for such
>> a large patch.  Maybe even some example usages.
>
> The patch originated from a buildsystem that uses buildroot and linux.
> Both use Kconfig and the buildsystem itself uses Kconfig. To configure
> a subproject you have to exit the toplevel Kconfig and restart to
> startup a subproject Kconfig, It is even more anoying when looking
> inside buildroot. It has in its turn subprojects uClibc, busybox,
> linux, crosstools-ng which all use Kconfig. The subtree patch
> does make it possible to unify all in one Kconfig.
>
> As an example, apply the patch, then add to <top>/Kconfig the lines:
>
> subsource "arch/sparc/Kconfig" "." ".config_sparc" "SPARC config" SPARC_
> CONFIG_
> subsource "arch/mips/Kconfig" "." ".config_mips" "MIPS config" MIPS_ CONFIG_
>
ETOOMUCHARGUMENT!

I wonder if we could not get all these parameters specified
dynamically in the Kconfig. This would replace the `mainmenu' entry
ala:

config
    title "Linux ..."
    prefix "CONFIG_"
    file .config
endconfig

That way, everytime you parse a tree, you can generate the structure
on-the-fly in a non-intrusive manner.

I have been thinking of doing something like that with a config file,
but doing it in the Kconfig would make much more sense.

Btw, what are you calling "<internal_prefix>" ?

Thanks,
 - Arnaud
