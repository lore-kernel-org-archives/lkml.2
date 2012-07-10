Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab2GJXeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:34:05 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:6003 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab2GJXeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:34:03 -0400
Message-ID: <1341963026.16730.828.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Add ACPI CPU hot-remove support
From: Toshi Kani <toshi.kani@hp.com>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: Jiang Liu <liuj97@gmail.com>, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 10 Jul 2012 17:30:26 -0600
In-Reply-To: <1341960978.1065.12.camel@lyra>
References: <1340981479-6521-1-git-send-email-toshi.kani@hp.com>
	 <4FF711DE.1030108@gmail.com> <1341602020.16730.695.camel@misato.fc.hp.com>
	 <4FF745F1.9030103@hp.com>  <1341608402.16730.730.camel@misato.fc.hp.com>
	 <1341960978.1065.12.camel@lyra>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 16:56 -0600, Khalid Aziz wrote:
> On Fri, 2012-07-06 at 15:00 -0600, Toshi Kani wrote:
> > Yes, offlining and eject are similar operations to a core as it alone
> > cannot be removed physically.  Ejecting a core is a logical eject
> > operation, which updates the status (_STA) of the object in ACPI after
> > offlining.  The difference from the offlining is that the ejected core
> > is no longer assigned to the partition.  Here is one example.  Say, a
> > core is assigned to a guest partition as a dedicated resource (ex. 100%
> > of its CPU time is bound to the partition).  Offlining this core saves
> > the power-consumption, but this core is still bound to the partition.
> > Ejecting the core removes it from the partition (logically), and allows
> > it to be assigned to other partition as a dedicated resource with
> > hot-add.
> > 
> 
> Ejecting a core is reasonable when eject happens from a guest. I still
> wonder what firmware would do if kernel calls eject method on a core
> when running on the native host platform. If firmware behavior is not
> well defined in this case, there might be some risk associated with
> calling eject method on core. 
> 
> Makes sense?

No, that's not the case.  The firmware only implements _EJ0 when it
supports the behavior on the environment.  It is true for both native
and virtual platforms.  Note that the presence of a CPU is abstracted
with _STA in ACPI, so it does not matter to the kernel if an eject is a
physical or logical operation.

For example, HP Superdome 2 implements _EJ0 on the native platform to
support capacity-on-demand and RAS features (which are supported by
HP-UX).  _EJ0 is still a logical eject operation in this case.

Thanks,
-Toshi



