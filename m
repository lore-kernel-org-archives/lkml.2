Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab0GTMlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 08:41:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581Ab0GTMld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 08:41:33 -0400
Message-ID: <4C45996B.3000003@redhat.com>
Date: Tue, 20 Jul 2010 14:41:15 +0200
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100628 Red Hat/3.1-1.el6 Thunderbird/3.1
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        davem@davemloft.net, Andy Gospodarek <gospo@redhat.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        Casey Leedom <leedom@chelsio.com>, Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH net-next] sysfs: add entry to indicate network interfaces
 with random MAC address
References: <4C457F72.8090708@redhat.com>	 <1279624844.2110.3.camel@achroite.uk.solarflarecom.com>	 <4C458CB7.3030508@redhat.com> <1279627656.2110.13.camel@achroite.uk.solarflarecom.com>
In-Reply-To: <1279627656.2110.13.camel@achroite.uk.solarflarecom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.07.2010 14:07, Ben Hutchings wrote:
> On Tue, 2010-07-20 at 13:47 +0200, Stefan Assmann wrote:
>> On 20.07.2010 13:20, Ben Hutchings wrote:
>>> On Tue, 2010-07-20 at 12:50 +0200, Stefan Assmann wrote:
>>>> From: Stefan Assmann <sassmann@redhat.com>

[snip]

>> Actually Dave Miller suggested to put it there. What other place is
>> there to put it?
> 
> If Dave said that then I'm sure it's OK.
> 
> However, if you define this as an interface flag (net_device::flags;
> <linux/if.h>) and add it to the set of changeable flags in
> __dev_change_flags(), user-space will be able to clear the flag if it
> later sets a stable address.

As I said I'm not that knowledgeable about this MAC address stealing
thing and I'm assuming that's what you're aiming at. Would you really
want/need it to be user-space writable? Currently all I can think of is
the scenario where you set a "stable" address that outlasts a reboot so
udev might be able to assign it a permanent name after it gets stable.

So it might make sense to have it writable, but I'd like to avoid to add
unnecessary complexity that may cause errors if it's not necessary.
Read-only is simple, just read the flag and deal with it.

Btw, the driver itself could also alter the flag. Then we'd have a well
defined way of setting a stable address.

  Stefan
--
Stefan Assmann         | Red Hat GmbH
Software Engineer      | Otto-Hahn-Strasse 20, 85609 Dornach
                       | HR: Amtsgericht Muenchen HRB 153243
                       | GF: Brendan Lane, Charlie Peters,
sassmann at redhat.com |     Michael Cunningham, Charles Cachera

> 
> Ben.
> 

