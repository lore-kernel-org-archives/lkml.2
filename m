Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935431Ab0KQUql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:46:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932364Ab0KQUqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:46:40 -0500
Date: Wed, 17 Nov 2010 12:45:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
        ext KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anders.grafstrom@netinsight.net" <anders.grafstrom@netinsight.net>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eparis@redhat.com" <eparis@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "marco.stornelli@gmail.com" <marco.stornelli@gmail.com>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        Aaron Durbin <adurbin@google.com>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH 0/2] kmsg_dump: adding to reboot, halt, poweroff and
 emergency_restart path
Message-Id: <20101117124518.6a0dd569.akpm@linux-foundation.org>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C12D6E2F5@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C12D6E2F5@USINDEVS01.corp.hds.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 09:58:18 -0500
Seiji Aguchi <seiji.aguchi@hds.com> wrote:

> Hi,
> 
> This series aims to develop logging facility for enterprise use.
> 
> It is important to save kernel messages reliably on enterprise system 
> because they are helpful for diagnosing system.
> 
> This series add kmsg_dump() to the paths loosing kernel messages.
> The use case is the following.
> 
> [Use case of reboot/poweroff/halt/emergency_restart]
> 
>  My company has often experienced the followings in our support service.
>  - Customer's system suddenly reboots.
>  - Customers ask us to investigate the reason of the reboot.
> 
>  We recognize the fact itself because boot messages remain in /var/log/messages.
>  However, we can't investigate the reason why the system rebooted,  because the last messages don't remain.
>  And off course we can't explain the reason.
>  
>  
>  We can solve above problem with this patch as follows.
>  Case1: reboot with command 
>    - We can see "Restarting system with command:" or ""Restarting system.".
> 
>  Case2: halt with command
>    - We can see "System halted.".
> 
>  Case3: poweroff with command
>    - We can see " Power down.".
> 
>  Case4: emergency_restart with sysrq.
>    - We can see "Sysrq:" outputted in __handle_sysrq().
> 
>  Case5: emergency_restart with softdog.
>    - We can see "Initiating system reboot" in watchdog_fire().
> 
>  So, we can distinguish the reason of reboot, poweroff, halt and emergency_restart.
> 
>  If customer executed reboot command, you may think the customer should know the fact.
>  However, they often claim they don't execute the command when they rebooted system by mistake.
> 
>  No evidential message remain on current Linux kernel, so we can't show the proof to the customer.
>  This patch improves this situation.
> 
> 
> The first patch alters mtdoops and ramoops to perform their actions only for KMSG_DUMP_PANIC,
> KMSG_DUMP_OOPS and KMSG_DUMP_KEXEC because they would like to log crashes only.
> 
> The latter patch adds kmsg_dump() to reboot, halt, poweroff and emergency_restart path.

Damn, that's a good changelog.  We can actually understand why you
wrote the patch, and see what its value is!

One thing: please don't send multiple patches with the same title. 
See Documentation/SubmittingPatches section 15.  I renamed these two
patches to

kmsg_dump: constrain mtdoops and ramoops to perform their actions only for KMSG_DUMP_PANIC

and

kmsg_dump: add kmsg_dump() calls to the reboot, halt, poweroff and emergency_restart paths

