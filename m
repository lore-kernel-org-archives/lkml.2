Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab1KRWxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:53:49 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:39727 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756392Ab1KRWxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:53:46 -0500
Message-ID: <4EC6E17E.9050405@xenotime.net>
Date: Fri, 18 Nov 2011 14:51:42 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "konrad.gaisler" <konrad@gaisler.com>
CC: linux-kernel@vger.kernel.org,
        linux kbuild list <linux-kbuild@vger.kernel.org>, mmarek@suse.cz,
        pefoley2@verizon.net, yann.morin.1998@anciens.enib.fr,
        sam@ravnborg.org, zippel@linux-m68k.org
Subject: Re: [PATCH 1/1] kconfig: Add a configuration subtree command to kconfig
References: <1321625774-12749-1-git-send-email-konrad@gaisler.com> <4EC69F65.20207@xenotime.net> <4EC6E179.1030703@gaisler.com>
In-Reply-To: <4EC6E179.1030703@gaisler.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 02:51 PM, konrad.gaisler wrote:
> On 11/18/2011 07:09 PM, Randy Dunlap wrote:
>> (changed linux-config@ to linux-kbuild@vger.kernel.org)
>>
>> On 11/18/2011 06:16 AM, Konrad Eisele wrote:
>>> New kconfig command "subsource":
>>> subsource "<kconfig>""<cwd>""<.config>""<title>"<internal_prefix>  <.config_prefix>
>>> Allocates<kconfig>  as a configuration subtree using<.config>  as the configuration
>>> file to save and load from.<cwd>  is the directory path to switch to for "source" to
>>> work, "<title>" is the Menu tile of the subtree,<internal_prefix>  is a internal prefix,
>>> and<.config_prefix>  is the prefix to append/remove when saving/loading<.config>.
>> That explains what but not why.  You need some justification(s) for such
>> a large patch.  Maybe even some example usages.
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
> subsource "arch/sparc/Kconfig" "." ".config_sparc" "SPARC config" SPARC_ CONFIG_
> subsource "arch/mips/Kconfig" "." ".config_mips" "MIPS config" MIPS_ CONFIG_
> (my mailclient breaks up the lines, it should be 2 lines only).
> 
> Then start "make xconfig" once to build "qconfig". The patch adds an
> extra option to qconfig (also mconfig, gconfig and nconfig) "-s". This
> option enables the "subsource" tag. Now start qconfig:
> $<path-to-qconfig>/qconfig -s Kconfig
> 
> Then you see a subtree "Sparc config" and "Mips config" that is a sparc
> and mips complete Kconfig. They are independent from another. The Sparc
> subtree is saved/loaded from .config_sparc, the  Mips subtree is
> saved/loaded from .config_mips. No namespace clash.
> 
> Note that without the "-s" option the Kconfig behaviour is as usual. I
> think it would be a help for many projects that use Kconfig.

OK, thanks for the explanation.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
