Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab2CHMVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 07:21:49 -0500
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:55104 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab2CHMVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 07:21:48 -0500
X-SENDER-IP: [85.230.168.211]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmiPAAmkWE9V5qjTPGdsb2JhbABCigaqFgOBChkBAQEBNzSCCgEBBAEyASMWDQULCAMYLhQlChouh2oJt0wTinCFCGMElUSFdY0I
X-IronPort-AV: E=Sophos;i="4.73,552,1325458800"; 
   d="scan'208";a="279199463"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 8 Mar 2012 13:23:03 +0100
To: =?iso-8859-1?Q?St=E9phane?= Chatty <chatty@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>,
        "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] HID: autoload hid-multitouch as needed
Message-ID: <20120308122303.GA11989@polaris.bitmath.org>
References: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com>
 <1331053026-21272-5-git-send-email-benjamin.tissoires@gmail.com>
 <alpine.LNX.2.00.1203072234550.29034@pobox.suse.cz>
 <20120308105737.GA11201@polaris.bitmath.org>
 <6E17845C-6F9F-4CB6-AA5D-DEEDCD2089E8@enac.fr>
 <20120308113009.GA11416@polaris.bitmath.org>
 <E18D154F-E02F-4DF9-8749-7F9EF92792CB@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E18D154F-E02F-4DF9-8749-7F9EF92792CB@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 12:48:24PM +0100, Stéphane Chatty wrote:
> 
> Le 8 mars 2012 à 12:30, Henrik Rydberg a écrit :
> > 
> > The device-driver matching is done in the kernel, but driver (aka
> > module) loading is done from userland. The crux is to be able to tell
> > userland what driver to load for a certain device. In this case, it
> > means giving more information to userland via the device/modalias
> > construct. Or at least, that is the question. :-)
> > 
> 
> Oook, I understand. The current solution used by distros is to load
> the hid module statically, but then we don't want to do it for every
> new kind of device-specific module, right? Is this your point?

Yes, half of it. The other half is the observation that the problem of
device-driver assignment we face for hid devices seems to originate in
the definition of what a hid device is, i.e., the hid device
identifier. If the identifier was more detailed and one could
construct a new hid device dynamically from the reports, the problem
would go away. Consequentually, a more detailed identifier would solve
the module-loading problem as well. The major concern I have is if
this is feasible from a compatibility point of view.

> I had the feeling that the current hid code was somehow trying to be
> universal, thus making the point moot, and figured that we would
> need to reintegrate hid-multitouch into hid-core at some
> point. You're suggesting another, more distributed option, in which
> new categories of HID devices appear from time to time and are
> handled in new modules, right? Sounds interesting to me, I'd like to
> hear what the original designers of the hid module think of it.

Me too. Reading through the module code, it really seems to put
userland in charge, only providing sufficient information to be able
to load the right modules. If this was fully possible in hid, at least
one of the special blacklists would disappear. One would also be able
to split the current hid-input into several different drivers, for
instance, gaining some clarity in addition to memory savings.

Henrik
