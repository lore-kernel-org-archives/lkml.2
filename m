Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab1GTO3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:29:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:63552 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab1GTO3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:29:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,235,1309762800"; 
   d="scan'208";a="28064132"
From: "Luck, Tony" <tony.luck@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Matthew Garrett <mjg@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>
Date: Wed, 20 Jul 2011 07:29:15 -0700
Subject: RE: [PATCH 4/9] pstore: Allow the user to explicitly choose a
 backend
Thread-Topic: [PATCH 4/9] pstore: Allow the user to explicitly choose a
 backend
Thread-Index: AcxG4MPY6rzDB3bjT6q6GCyghP1XfQAB8J2Q
Message-ID: <987664A83D2D224EAE907B061CE93D5301E9E6863C@orsmsx505.amr.corp.intel.com>
References: <1311021033-7483-1-git-send-email-mjg@redhat.com>
 <1311021033-7483-5-git-send-email-mjg@redhat.com>
 <20110720132706.GA19934@dumpdata.com>
In-Reply-To: <20110720132706.GA19934@dumpdata.com>
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

> > +	if (backend && strcmp(backend, psi->name)) {
>
> Is there a limit of how big the backend name can be? If so would it
> make sense to use to strncmp?

I'd expect that the name will generally be short. It does get
embedded in the names of files that appear in the pstore file
system - so there is a 255 pathname component limit, which means
that backends should limit themselves to 200 or so characters.

So I suppose we could check to see if the backend is trying
to use a name so long that it would cause problems - but I'm
not sure how much value that would really add. I don't think
that loading pstore modules with dumb names is an interesting
attack vector.

-Tony
