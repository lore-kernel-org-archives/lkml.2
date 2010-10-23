Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab0JWPoG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 11:44:06 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:44422 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738Ab0JWPoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 11:44:04 -0400
Date: Sat, 23 Oct 2010 16:43:56 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Richard Hughes <hughsient@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / Battery: Return -ENODATA for unknown values in
	get_property()
Message-ID: <20101023154355.GB8994@sucs.org>
References: <20101016141321.GA11054@sucs.org> <20101017131016.GB13015@khazad-dum.debian.net> <20101017145025.GA32599@sucs.org> <201010172032.43206.rjw@sisk.pl> <20101021165420.GA8718@sucs.org> <AANLkTimJQN=SNCDwOJLo0MKXEcutTKZ3qd81hNAKeXGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimJQN=SNCDwOJLo0MKXEcutTKZ3qd81hNAKeXGg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 01:31:28PM +0100, Richard Hughes wrote:
> On 21 October 2010 17:54, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> > I guess there are a whole bunch of other attributes that could
> > theoretically be -1 and shouldn't be used if they return it...
> 
> I think checking for <0 is probably a good idea, and I'm a little
> surprised we don't do this already. Patch welcome, if this is what you
> decide to do.

I can only guess that at some point in upower's past negative values for
current_rate were found to be valid so upower took the route of making
them absolute to work around that behaviour. If so, it would be good to
know whether there are still devices in this category running a stock
kernel.

If the latest patch to return -ENODEV goes in, then there's the
possibility for upower to detect the unknown state and report unknown
back to its users. Would the existing interfaces support outputting
unknown instead of a number? If not (and there are no plans to) I
suspect the best thing to do is to remove the test for 0xffff and
continue to return 0.

-- 
Sitsofe | http://sucs.org/~sits/
