Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2FMXOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 19:14:40 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:55108 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab2FMXOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 19:14:39 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>, Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "rob@landley.net" <rob@landley.net>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Wed, 13 Jun 2012 19:14:16 -0400
Subject: RE: [RFC][Patch]efi_pstore:Introduce an efi_pstore_overwrite
 parameter to avoid missing messages in NVRAM
Thread-Topic: [RFC][Patch]efi_pstore:Introduce an efi_pstore_overwrite
 parameter to avoid missing messages in NVRAM
Thread-Index: Ac1Jaf3kQfy2nRzQSNG3UORn8S5p+AAc0YIAAA6J6JAAGwBGkA==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2E5A4DB451@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2E5A4DB2B8@USINDEVS01.corp.hds.com>
 <CAGTjWtAb3XrsTtkvW=G0YN1RCVxYxcPksSh3jEogeEu4qWqv1Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F1930C820@ORSMSX103.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1930C820@ORSMSX103.amr.corp.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1206130261
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your comment.

> Since the EFI backend has so little storage space ... perhaps it should have some overwrite rules built into it?

I think so.
If multiple triggers don't stride across the reboot, I think we can make an automated rule.

> If this seems a plausible route ... we'd need to tabulate the overwrite rules.  I think they are:
> 	shutdown/reboot/kexec - can be overwritten by OOPS

In my usecase, emergency_restart can be overwritten by OOPS

> 	OOPS can be overwritten by panic
> 	panic can never be overwritten

I can make a patch in accordance with the rule above.

Should it be in pstore layer?
  - introducing a new global variable storing a previous trigger.
  - deciding if we can continue by checking a value of previous trigger at the beginning of pstore_dump().


> I'd like to avoid a kernel parameter ... chances are too high that the machine would be automatically rebooted without the right boot
> argument.

 But, I'm not sure if we can simply apply the rule above in case where multiple triggers stride across the reboot...
In this case,  emergency_restart cannot be overwritten by panic..

Anyway, I will consider the possibility of avoiding a kernel parameter.

Seiji
