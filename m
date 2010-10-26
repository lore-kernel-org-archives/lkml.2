Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201Ab0JZRuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:50:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760167Ab0JZRuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:50:14 -0400
Subject: Re: [PATCH] x86/pvclock-xen: zero last_value on resume
From: Glauber Costa <glommer@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        kvm-devel <kvm@vger.kernel.org>,
        =?ISO-8859-1?Q?C=E9dric?= Schieli <cschieli@gmail.com>,
        Eelco Dolstra <e.dolstra@tudelft.nl>,
        Olivier Hanesse <olivier.hanesse@gmail.com>
In-Reply-To: <4CC708DE.1070000@goop.org>
References: <4CC708DE.1070000@goop.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat Inc.
Date: Tue, 26 Oct 2010 15:48:54 -0200
Message-ID: <1288115334.3530.7.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 09:59 -0700, Jeremy Fitzhardinge wrote:
> 
> If the guest domain has been suspend/resumed or migrated, then the
> system clock backing the pvclock clocksource may revert to a smaller
> value (ie, can be non-monotonic across the migration/save-restore).
> Make sure we zero last_value in that case so that the domain
> continues to see clock updates.
> 
> [ I don't know if kvm needs an analogous fix or not. ]
After migration, save/restore, etc, we issue an ioctl where we tell
the host the last clock value. That (in theory) guarantees monotonicity.

I am not opposed to this patch in any way, however.


