Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab1FGVgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:36:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:16903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932467Ab1FGVf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:35:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,334,1304319600"; 
   d="scan'208";a="13179021"
From: "Luck, Tony" <tony.luck@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Matt_Domsch@dell.com" <Matt_Domsch@dell.com>
Date: Tue, 7 Jun 2011 14:35:56 -0700
Subject: RE: [PATCH v2 3/3] efi: Add support for using efivars as a pstore
 backend
Thread-Topic: [PATCH v2 3/3] efi: Add support for using efivars as a pstore
 backend
Thread-Index: AcwlVTaEsFZxM4chSmCSDTnMJpJxywABRhLQ
Message-ID: <987664A83D2D224EAE907B061CE93D5301E70D902F@orsmsx505.amr.corp.intel.com>
References: <1307470562-15633-1-git-send-email-mjg@redhat.com>
 <1307470562-15633-4-git-send-email-mjg@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301E70D8EAE@orsmsx505.amr.corp.intel.com>
 <20110607202517.GA732@srcf.ucam.org>
 <987664A83D2D224EAE907B061CE93D5301E70D8F43@orsmsx505.amr.corp.intel.com>
 <20110607205507.GA1386@srcf.ucam.org>
In-Reply-To: <20110607205507.GA1386@srcf.ucam.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah. I guess the question then is whether the mediation should be in 
> pstore or at the platform backend level. strcmp in pstore_register seems 
> somehow fragile for this, but I guess it'd work?

I don't think it all that fragile.  All the back ends will have
unique names.  If the user doesn't specify a pstore= argument we
keep the current "first past the post" method. If they do, then they
can choose which one, or specify pstore=none (or even pstore=not-bloody-likely,
since any not matching string will disable) to turn it off altogether.

-Tony
