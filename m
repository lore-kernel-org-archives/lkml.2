Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab0J1T6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 15:58:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63872 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab0J1T6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 15:58:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ouqrIXzlJNHmJm0hyQaKgg+GYVG24jdBrxYWWoT4mOlS2KRAV/hMIK63ZApZdcIb9x
         GeTafZX4z6lUBtJASB+2G09O9DFJzJeBsitGOOI31PDUK4xwuzgTIrWlHSaTvspXK6ub
         Z2jiO65JiZjGRCcbhT7VN0mGvNU+xlN0wmiNU=
Subject: Re: [RFC][Patch] Adding kmsg_dump() to
 reboot/halt/poweroff/emergency_restart path
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Artem.Bityutskiy@nokia.com,
        ext KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anders.grafstrom@netinsight.net" <anders.grafstrom@netinsight.net>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eparis@redhat.com" <eparis@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
In-Reply-To: <20101027163505.c88095da.akpm@linux-foundation.org>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C11B4B724@USINDEVS01.corp.hds.com>
	 <20101019173303.A205.A69D9226@jp.fujitsu.com>
	 <1287478272.9272.9.camel@localhost>
	 <20101027163505.c88095da.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 22:58:04 +0300
Message-ID: <1288295884.1766.10.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 16:35 -0700, Andrew Morton wrote:
> > > I think mtdoops user don't want to dump logs if a system reboot/poweroff
> > > safely because mtd device have write count limitation. and they are main
> > > user of kmsg_dump().
> 
> mtdoops was the only user until ramoops came along.
> 
> > Right, at least this is how we use mtdoops - we log crashes.
> 
> Fair enough.  So I suppose the existing clients (mtdoops_do_dump and
> ramoops_do_dump) should be altered to inspect the `reason' argument,
> and return if it isn't KMSG_DUMP_OOPS, KMSG_DUMP_PANIC or
> KMSG_DUMP_KEXEC (I assume?)

I agree, then mtdoops/ramoops can be tweaked to handle other messages.

> If that sounds suitable then I'd ask Seiji to update and resend the
> patch, along with a complete changelog as earlier dicussed.

Yes, I think the patch makes perfect sense, just the existing
functionality should not be changed as a side effect.

> I'd suggest doing it as two patches, the first of which alters mtdoops
> and ramoops to perform their actions only for the appropriate `reason'
> values.

Right, thanks.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

