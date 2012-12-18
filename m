Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab2LRSYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:24:31 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60974 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753476Ab2LRSYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:24:30 -0500
Message-ID: <1355855069.30366.14.camel@joe-AO722>
Subject: Re: [PATCH 2/2] MCE, AMD: MCE decoding support for AMD Family 16h
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jacob Shin <jacob.shin@amd.com>, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Dec 2012 10:24:29 -0800
In-Reply-To: <20121218171915.GE31255@liondog.tnic>
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
	  <1355773188-5241-2-git-send-email-jacob.shin@amd.com>
	 <20121218171915.GE31255@liondog.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 18:19 +0100, Borislav Petkov wrote:
> On Mon, Dec 17, 2012 at 01:39:48PM -0600, Jacob Shin wrote:
> > Add MCE decoding logic for AMD Family 16h processors.
[]
> > +		switch (xec) {
> > +		case 0x04 ... 0x05:
> > +			pr_cont("Parity error in %s.\n",
> > +				(r4 == R4_RD ? "IBUFF" : "OBUFF"));
> 
> or
> 			pr_cont("%sBUFF parity error.\n", ((xec == 4) ? "I" : "O"));

or without all the unnecessary parens and using char:

			pr_cont("%cBUFF parity error\n", xec == 4 ? 'I' : 'O');


