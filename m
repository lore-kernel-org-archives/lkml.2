Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab0GAAgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 20:36:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49302 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab0GAAgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 20:36:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 1 Jul 2010 09:31:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg KH <gregkh@suse.de>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] memory hotplug disable boot option
Message-Id: <20100701093130.c5e2b564.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100630154755.GB12158@suse.de>
References: <20100628154455.GA13918@suse.de>
	<1277769867.8354.531.camel@nimitz>
	<20100629115232.38BC.A69D9226@jp.fujitsu.com>
	<1277827384.8354.3413.camel@nimitz>
	<20100629180415.GB1240@suse.de>
	<20100630093251.a30ed1e0.kamezawa.hiroyu@jp.fujitsu.com>
	<20100630154755.GB12158@suse.de>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 08:47:55 -0700
Greg KH <gregkh@suse.de> wrote:
> > and adding a scalable interface for large scale machines ?
> > I'd like to consider something..
> 
> Dynamically changing the layout on big memory boxes makes sense to me,
> how about you?
> 

like this ?
==
boot option:
memory_sysfs_layout=compact
memory_sysfs_layout=auto (default)
memory_sysfs_layout=full

Considering briefly, how about this compact layout ?

/sys/devices/system/memory/:
                            list, hide, show, memoryX...

list: // show available memory index list.
  #cat list
   0 1 2 ....10000...

show: //an interface to enable the interface.
  #echo INDEX > memory_index
  will create memoryINDEX diretory.

hide: //an interface to hide the interface.
  #echo INDEX > memory_hide
  will remove memoryINDEX sysfs directory.


In compact mode, all memoryX interface are hidden at boot.
In full mode, all memoryX interaface are shown.
The Boot option just affects status at boot. If users want, he can make
all memory sysfs in shown state.

At hot-add event (via acpi) or probe-event, newly created memory section
should be start from "shown" mode. hotplug scirpt can hide it after online.

At hot-remove, the users has to offline memory before hotplug. He'll has
to do check list and show interface.

I think this change is not very difficult technically but can this kind of
interface be allowed ?

Thanks,
-Kame




