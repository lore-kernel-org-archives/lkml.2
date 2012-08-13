Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab2HMP0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:26:33 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:28394 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2HMP0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:26:31 -0400
Message-ID: <1344871282.3010.988.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Add ACPI CPU hot-remove support
From: Toshi Kani <toshi.kani@hp.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: lenb@kernel.org, khalid.aziz@hp.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 13 Aug 2012 09:21:22 -0600
In-Reply-To: <CAOEr4mpL952Z2iPuhfad+jhxUpOdHPRenEVmTUkU9LC8kKR29w@mail.gmail.com>
References: <1340981479-6521-1-git-send-email-toshi.kani@hp.com>
	 <4FF711DE.1030108@gmail.com>	<1341602020.16730.695.camel@misato.fc.hp.com>
	 <4FF745F1.9030103@hp.com>	<1341608402.16730.730.camel@misato.fc.hp.com>
	 <CAOEr4mpL952Z2iPuhfad+jhxUpOdHPRenEVmTUkU9LC8kKR29w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerry, Khalid,

On Mon, 2012-07-09 at 02:40 +0000, Jiang Liu wrote:
> Hi Khalid,
>  It depends on it's running on physical or virtualizaiton host. If
> it's a native OS running on physical platforms, we have real platforms
> to support physical processor, memory board, IOH(PCIe host bridge) and
> node (including mem/cpu/IOH) hotplug, but we haven't really seen a
> platform supporting CPU(core) hotplug yet.
> I think CPU(core) hotplug is for virtualization, where each physical
> core is presented as a virtual processor to guest OS. So to
> dynamically reconfigure guest OS capabilties, we need to support CPU
> hotplug.

Agreed.  We need to enable CPU hot-add/remove features for
visualization, such as KVM.
 
>  Actually we are working on a project to enhance ACPI based physical
> device hotplug, which aims to unify the way to support physical
> processor(ACPI Container), memory board(ACPI Memory Device), PCI root
> bridge(ACPI PCI Host bridge) and node (ACPI Container) hotplug.

Cool.

>  Toshi, seems there's ongoing effort from both you, Yinghai, Yasuaki
> Ishimatsu and us to enable ACPI based physical device hotplug. It
> would be great if we could cooperate on this area.

Absolutely!  It will be great for us to collaborate in this area. 


Gerry, Khalid, please let me know if you have any further comments on
this patch.

Thanks,
-Toshi



>  Thanks!
>  Gerry
> 
> 
>  
> On Sat, Jul 7, 2012 at 5:00 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Fri, 2012-07-06 at 14:09 -0600, Khalid Aziz wrote:
> > On 07/06/2012 01:13 PM, Toshi Kani wrote:
> >
> > >
> > > For step 2) and 4), I am wondering if they are relevant to CPU
> hotplug 
> > > these days.  In ACPI namespace, a processor object represents a
> logical
> > > processor (or a core when hyper-threading is disabled).  A
> physical
> > > processor (i.e. a socket) usually has multiple cores, and memory
> > > controller and bus interface are part of the socket functionality.
> > > Hence, I think step 2) and 4) belong to socket-level hot-removal
> > > operation, which can be implemented as container hot-remove when a
> > > socket is represented with a container object.
> >
> > What does it mean to eject just a core in that case? If there are
> seven
> > other cores in the physical processor and you get a request to eject
> > one core, what would you expect kernel to do - simply move all
> processes
> > and interrupts off of that core, take it out of scheduling
> consideration
> > and simply idle the core? If yes, how is that any different from
> simply
> > offlining a core?
>         
>         
> Yes, offlining and eject are similar operations to a core as it alone
> cannot be removed physically.  Ejecting a core is a logical eject
> operation, which updates the status (_STA) of the object in ACPI after
> offlining.  The difference from the offlining is that the ejected core
> is no longer assigned to the partition.  Here is one example.  Say, a
> core is assigned to a guest partition as a dedicated resource (ex.100%
> of its CPU time is bound to the partition).  Offlining this core saves
> the power-consumption, but this core is still bound to the partition.
> Ejecting the core removes it from the partition (logically), and
> allows it to be assigned to other partition as a dedicated resource
> with hot-add.
>         
>         
> > If you are ejecting individual cores at a time, do you
> > keep track of how many you have ejected and then eject the entire
> physical
> > CPU along with memory and IOH associated with the socket when the
> last
> > core is ejected?
>         
>         
> It depends on the firmware implementation, but typically the answer is
> no.  _EJ0 of a core object only removes the associated core object. It
> will require a separate socket hot-remove request to eject the
> socket-level resources.  That is, the OS may not call _EJ0 of a socket
> object from the core hot-remove operation just because all children
> cores are removed.
>         
> Thanks,
> -Toshi
>         
>         
>         
> 


