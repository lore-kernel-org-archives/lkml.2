Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab2FMUnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 16:43:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:44969 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab2FMUnV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 16:43:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="155997836"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mike Waychison <mikew@google.com>, Seiji Aguchi <seiji.aguchi@hds.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "rob@landley.net" <rob@landley.net>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][Patch]efi_pstore:Introduce an efi_pstore_overwrite
 parameter to avoid missing messages in NVRAM
Thread-Topic: [RFC][Patch]efi_pstore:Introduce an efi_pstore_overwrite
 parameter to avoid missing messages in NVRAM
Thread-Index: Ac1Jaf3kQfy2nRzQSNG3UORn8S5p+AAc0YIAAA6J6JA=
Date: Wed, 13 Jun 2012 20:43:17 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1930C820@ORSMSX103.amr.corp.intel.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2E5A4DB2B8@USINDEVS01.corp.hds.com>
 <CAGTjWtAb3XrsTtkvW=G0YN1RCVxYxcPksSh3jEogeEu4qWqv1Q@mail.gmail.com>
In-Reply-To: <CAGTjWtAb3XrsTtkvW=G0YN1RCVxYxcPksSh3jEogeEu4qWqv1Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>    4. kernel panics again before a user checks the 1st panic messages in NVRAM.
>
>
>    To avoid missing 1st panic messages, this patch adds a new parameter ,efi_pstore_overwrite,
>    to efi_pstore so that we can specify whether efi_pstore overwrites existing entries in NVRAM or not.

Since the EFI backend has so little storage space ... perhaps it should
have some overwrite rules built into it?

E.g. in the case where there is an OOPS already logged, and a panic happens,
then I think the right thing to do is overwrite the oops with the panic.
[The oops *might* have already made it to /var/log/messages, but even if
it didn't, a user with a PICK ONLY ONE choice would have to go for the
log of the panic]

In the situation you describe where we already have a panic, then
I don't think than anyone would want the earlier panic to be overwritten
by the new one.

If this seems a plausible route ... we'd need to tabulate the overwrite
rules.  I think they are:
	shutdown/reboot/kexec - can be overwritten by OOPS
	OOPS can be overwritten by panic
	panic can never be overwritten

I'd like to avoid a kernel parameter ... chances are too high that the
machine would be automatically rebooted without the right boot argument.

-Tony
