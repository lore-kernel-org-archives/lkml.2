Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab1GNG7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 02:59:30 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:43460 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751084Ab1GNG73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 02:59:29 -0400
X-Authenticated: #7756412
X-Provags-ID: V01U2FsdGVkX19BP4lSOq1BAx13OTwguo+PYqVqp74Wmc80qxOufI
	fs6jYj5HKzVfZT
Message-ID: <4E1E93C9.4020109@gmx.net>
Date: Thu, 14 Jul 2011 08:59:21 +0200
From: Arne Jansen <sensille@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>
CC: NeilBrown <neilb@suse.de>,
        Nico Schottelius <nico-lkml-20110623@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: Mis-Design of Btrfs?
References: <20110623105337.GD3753@ethz.ch>	<20110627164637.377314e2@notabene.brown>	<4E0AF091.9030301@redhat.com> <20110714155620.6e9ac2cc@notabene.brown> <4E1E866E.2050405@redhat.com>
In-Reply-To: <4E1E866E.2050405@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.07.2011 08:02, Ric Wheeler wrote:
> On 07/14/2011 06:56 AM, NeilBrown wrote:
>> I'm certainly open to suggestions and collaboration. Do you have in
>> mind any
>> particular way to make the interface richer??
>
> If a file system uses checksumming or other data corruption detection
> bits, it can detect that it got bad data on a write. If that data was
> protected by RAID, it would like to ask the block layer to try to read
> from another mirror (for raid1) or try to validate/rebuild from parity.
>
> Today, I think that a retry will basically just give us back a random
> chance of getting data from a different mirror or the same one that we
> got data from on the first go.

Another case that comes to mind is the 'remove device' operation.
To accomplish this, btrfs just rewrites all the data that reside
on that device to other drives.
Also, scrub and my recently posted readahead patches make heavy
use of the knowledge of how the raid is laid out. Readahead always
uses as many drives as possible in parallel, while trying to
avoid unnecessary seeks on each device.

-Arne

>
> Chris, Alasdair, was that a good summary of one concern?
>
> Thanks!
>
> Ric
>
