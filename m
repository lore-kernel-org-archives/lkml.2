Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab0FXRqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 13:46:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:28574 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466Ab0FXRqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 13:46:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,475,1272870000"; 
   d="scan'208";a="579582858"
From: "Othman, Ossama" <ossama.othman@intel.com>
To: =?iso-8859-1?Q?Henri_H=E4kkinen?= <henrih81@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "gregkh@suse.de" <gregkh@suse.de>, Matti Lammi <mattij.lammi@gmail.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 24 Jun 2010 10:46:41 -0700
Subject: RE: [PATCH] Staging: memrar: Moved memrar_allocator struct into
 memrar_allocator.c
Thread-Topic: [PATCH] Staging: memrar: Moved memrar_allocator struct into
 memrar_allocator.c
Thread-Index: AcsTgJGrQ3V5Mec5QqGxLkkVe91amgAQ2pEQ
Message-ID: <A5FE05C4C76E4C4CAB15D9962B96FC950CEA181645@orsmsx510.amr.corp.intel.com>
References: <A5FE05C4C76E4C4CAB15D9962B96FC950CEA180A03@orsmsx510.amr.corp.intel.com>
 <1C8E6A7A-45FE-4862-A6AD-397548588F96@gmail.com>
In-Reply-To: <1C8E6A7A-45FE-4862-A6AD-397548588F96@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >> size_t memrar_allocator_largest_free_area(struct memrar_allocator
> *allocator)
> >> {
> >> -	if (allocator == NULL)
> >> -		return 0;
> >> -	return allocator->largest_free_area;
> >> +	size_t tmp = 0;
> >> +
> >> +	if (allocator != NULL) {
> >> +		mutex_lock(&allocator->lock);
> >> +		tmp = allocator->largest_free_area;
> >> +		mutex_unlock(&allocator->lock);
> >
> > This doesn't seem to make any sense (in either version). The moment
> you
> > drop the lock the value in "tmp" becomes stale as the allocator could
> > change it. ?
> >
> 
> The idea was proposed by Ossama Othman in his earlier reply.

:-) 

[OO] > > Certainly the allocator->largest_free_area value could be updated
> after the lock is released and by the time it is returned to the user
> (for statistical purposes), but at least the internal allocator state
> would remain consistent in the presences of multiple threads.

My suggestion focused solely on hiding the allocator lock from the caller.  The TOCTOU race I alluded to above exists in the current version of the code, and was not introduced with the change I proposed to your patch.

HTH,
-Ossama
