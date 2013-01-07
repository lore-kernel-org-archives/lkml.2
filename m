Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab3AGKyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:54:38 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:64896 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3AGKyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:54:37 -0500
X-IronPort-AV: E=Sophos;i="4.84,423,1355097600"; 
   d="scan'208";a="484024"
Message-ID: <1357556073.7989.12.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump
 implementation
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Jan Beulich" <JBeulich@suse.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Date: Mon, 7 Jan 2013 10:54:33 +0000
In-Reply-To: <50EAA795.6030101@citrix.com>
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
	 <50DBC856.6030208@zytor.com>
	 <791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>
	 <50DC58C4.3000307@citrix.com> <874nj7qsor.fsf@xmission.com>
	 <50E41973.9050705@citrix.com>
	 <20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>
	 <50E6F81D02000078000B3245@nat28.tlf.novell.com>
	 <20130104170751.GB3472@host-192-168-1-59.local.net-space.pl>
	 <20130104191146.GC6721@phenom.dumpdata.com>
	 <1357554350.14291.134.camel@zakaz.uk.xensource.com>
	 <50EAA795.6030101@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-07 at 10:46 +0000, Andrew Cooper wrote:

> Given that /sbin/kexec creates a binary blob in memory, surely the most 
> simple thing is to get it to suitably mlock() the region and give a list 
> of VAs to the hypervisor.

More than likely. The DOMID_KEXEC thing was just a radon musing ;-)

> This way, Xen can properly take care of what it does with information 
> and where.  For example, at the moment, allowing dom0 to choose where 
> gets overwritten in the Xen crash area is a recipe for disaster if a 
> crash occurs midway through loading/reloading the crash kernel.

That's true. I think there is a double buffering scheme in the current
thing and we should preserve that in any new implementation.

Ian.

