Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab0KLPNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:13:44 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:30314 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752408Ab0KLPNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:13:43 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: cgpZCdcVM1kk3guLU.Y2iQfzdBZ1hApsv1t.4EwBVnTE4_H
 vGzDaMT2r3UnG.EMiZjFgO0Y52XOeIhR01y80WDQyM.WH9cmdOW5slk.GcTw
 W1R1lYqlL1QQkOSQoec1Iaml5c4Q3Gv.JeMTrQ5rnM4nXQytSkCgfxlukZak
 K4yQtYLPFziQ596Vna3djJ5rSBAPkQytsnS4UNRGA2VYriHt2ymQWzpn.fv_
 Q
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 12 Nov 2010 09:13:40 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Richard Kennedy <richard@rsk.demon.co.uk>
cc: Pekka Enberg <penberg@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH/RFC] MM slub: add a sysfs entry to show the calculated
 number of fallback slabs
In-Reply-To: <1289561309.1972.30.camel@castor.rsk>
Message-ID: <alpine.DEB.2.00.1011120911310.11746@router.home>
References: <1289561309.1972.30.camel@castor.rsk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010, Richard Kennedy wrote:

> On my desktop workloads (kernel compile etc) I'm seeing surprisingly
> little slab fragmentation. Do you have any suggestions for test cases
> that will fragment the memory?

Do a massive scan through huge amounts of files that triggers inode and
dentry reclaim?

> + * Note that this can give the wrong answer if the user has changed the
> + * order of this slab via sysfs.

Not good. Maybe have an additional counter in kmem_cache_node instead?
