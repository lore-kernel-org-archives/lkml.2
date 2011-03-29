Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1C2QSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:18:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24080 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab1C2QST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:18:19 -0400
Message-ID: <4D92063C.8040202@oracle.com>
Date: Tue, 29 Mar 2011 09:18:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Shyam_Iyer@Dell.com, jbarnes@virtuousgeek.org, mjg59@srcf.ucam.org,
        Narendra_K@Dell.com, viro@zeniv.linux.org.uk, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Matt_Domsch@Dell.com, Charles_Rose@Dell.com, Jordan_Hargrave@Dell.com
Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by allmodconfig
References: <20110223131536.GA16707@fedora14-r610.blr.amer.dell.com>	<20110223131734.GA6275@srcf.ucam.org>	<20110304101509.7eef7475@jbarnes-desktop>	<20110328080220.1390d28e.randy.dunlap@oracle.com>	<DBFB1B45AF80394ABD1C807E9F28D15702659CFB3D@BLRX7MCDC203.AMER.DELL.COM>	<4D90EDE8.9070306@oracle.com> <87oc4u4rn4.fsf@devron.myhome.or.jp>
In-Reply-To: <87oc4u4rn4.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D920640.0115,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/11 18:55, OGAWA Hirofumi wrote:
> Randy Dunlap <randy.dunlap@oracle.com> writes:
> 
>>> I don't get this.. you should not be getting CONFIG_NLS=m unless you
>>> have stripped you config files really.. :-) Is it possible to get
>>> your .config to hit this issue.
>>
>> I haven't stripped any config files -- but they are randconfig files.
>> Two (2) config files that cause build failures are attached.
> 
> config PCI_IOAPIC
> 	bool
> 	depends on PCI
> 	depends on ACPI
> 	depends on HOTPLUG
> 	default y
> 
> select NLS if (DMI || ACPI)

Ugh.  That looks seriously mucked up.
Dell people, have you checked what it is linux-next for this pci-label stuff?

Jesse, I would drop the b0rked pieces and ask for a new patch.


> I guess this is simply wrong. It will be parsed as
> 
> config PCI_IOAPIC
> 	bool
> 	depends on PCI
> 	depends on ACPI
> 	depends on HOTPLUG
> 	default y
> 	select NLS if (DMI || ACPI)
> 
> How about something like the following?
> 
> config PCI_LABEL
> 	bool
>         select NLS
>         depends on (DMI || ACPI)

What sets/enables it then?
or did you mean:
	def_bool y
and in that case, should it be a user-visible & user-changeable kconfig option?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
