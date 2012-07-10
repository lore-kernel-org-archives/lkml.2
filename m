Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab2GJW4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:56:21 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:13396 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab2GJW4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:56:20 -0400
Subject: Re: [PATCH] ACPI: Add ACPI CPU hot-remove support
From: Khalid Aziz <khalid.aziz@hp.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Jiang Liu <liuj97@gmail.com>, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1341608402.16730.730.camel@misato.fc.hp.com>
References: <1340981479-6521-1-git-send-email-toshi.kani@hp.com>
	 <4FF711DE.1030108@gmail.com> <1341602020.16730.695.camel@misato.fc.hp.com>
	 <4FF745F1.9030103@hp.com>  <1341608402.16730.730.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Jul 2012 16:56:18 -0600
Message-ID: <1341960978.1065.12.camel@lyra>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 15:00 -0600, Toshi Kani wrote:
> Yes, offlining and eject are similar operations to a core as it alone
> cannot be removed physically.  Ejecting a core is a logical eject
> operation, which updates the status (_STA) of the object in ACPI after
> offlining.  The difference from the offlining is that the ejected core
> is no longer assigned to the partition.  Here is one example.  Say, a
> core is assigned to a guest partition as a dedicated resource (ex. 100%
> of its CPU time is bound to the partition).  Offlining this core saves
> the power-consumption, but this core is still bound to the partition.
> Ejecting the core removes it from the partition (logically), and allows
> it to be assigned to other partition as a dedicated resource with
> hot-add.
> 

Ejecting a core is reasonable when eject happens from a guest. I still
wonder what firmware would do if kernel calls eject method on a core
when running on the native host platform. If firmware behavior is not
well defined in this case, there might be some risk associated with
calling eject method on core. 

Makes sense?

-- 
Khalid Aziz <khalid.aziz@hp.com>

