Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab0GLQ4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:56:37 -0400
Received: from exprod6og117.obsmtp.com ([64.18.1.39]:35728 "HELO
	exprod6og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755817Ab0GLQ4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:56:35 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: nic enumeration
Date: Mon, 12 Jul 2010 12:56:31 -0400
Message-ID: <D3F292ADF945FB49B35E96C94C2061B90C3CFABA@nsmail.netscout.com>
In-Reply-To: <AANLkTilYZTwekbqKCXEaT6Yo3UTDl9tRHJlRdwpSg_IH@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: nic enumeration
Thread-Index: AcsfrWbGbNcOEMgVTgGyzV/NQbOUcwCKxOdg
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com><20100708012120.GB11419@auslistsprd01.us.dell.com><D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com><82tyo9i0n2.fsf@mid.bfk.de><D3F292ADF945FB49B35E96C94C2061B90C3CF3E9@nsmail.netscout.com><AANLkTik4JOoNFSoML98j8LPJhJjVpWd8om-OYMGp3s9V@mail.gmail.com><D3F292ADF945FB49B35E96C94C2061B90C3CF4C5@nsmail.netscout.com> <AANLkTilYZTwekbqKCXEaT6Yo3UTDl9tRHJlRdwpSg_IH@mail.gmail.com>
From: "Loke, Chetan" <Chetan.Loke@netscout.com>
To: "Steve Fink" <sphink@gmail.com>
Cc: "Florian Weimer" <fweimer@bfk.de>, <linux-net@vger.kernel.org>,
        "Matt Domsch" <Matt_Domsch@dell.com>,
        "Michael Di Domenico" <mdidomenico4@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kay.sievers@vrfy.org>
X-OriginalArrivalTime: 12 Jul 2010 16:56:33.0258 (UTC) FILETIME=[2E8E94A0:01CB21E3]
X-TM-AS-Product-Ver: SMEX-8.0.0.4125-6.000.1038-17500.007
X-TM-AS-Result: No--19.585100-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Steve Fink [mailto:sphink@gmail.com]
> Sent: July 09, 2010 5:27 PM
> To: Loke, Chetan
> Cc: Florian Weimer; linux-net@vger.kernel.org; Matt Domsch; Michael Di
> Domenico; linux-kernel@vger.kernel.org; kay.sievers@vrfy.org
> Subject: Re: nic enumeration
> 
> 
> Your problem is different from the one that began this thread. Can you
> describe your situation more fully?
> 

Sorry guys, I thought I mentioned my requirement. And I apologize for
pulling in my discussion in this thread.

Requirement:
I've a box with 'M' NICs. During install time, all the h/w config is
static, customers will configure the box. They would say use 'ethX' for
task-foo and 'ethY' for task-bar.
All this while our-apps where happy because we would never modify the
h/w config(single NIC vendor). So the configuration was pretty static.
However, we now let customers add/replace NICs from different vendors(so
different drivers will get loaded).The older 'ethX' might now map to a
newly-inserted-NICs-mac. So I would now like an 'ethX' agnostic way of
addressing the NICs and BTW we can't reboot the box[look below why].

Possible solution:
S1)I thought symlink[or a reference etc] would solve this problem. 
S2)I have another idea in mind(using mac-ids,enhance dev_ioctl[introduce
SIOCGHWADDR_TO_IFNAMEINDEXMAP] and traverse
for_each_netdev::for_each_dev_addrs) but I will wait for everyone's
suggestions because there might be an easy way.

Why can't I reboot?
Imagine the above configuration within a VM. Some customers have as many
as 75+ VMs deployed and we cannot afford to reboot the VMs after adding
a new (virtual)vNIC. The newly added vNIC is seen by the guest as if it
were a hot-insertion.


> I only partially understand your problem, but I am still wondering if
> my bridge idea would work for you. (Preferably combined with udev
> rules or whatever so the bridges are unnecessary after the next
> reboot.)

Why a bridge? Just to get around naming issues?

Regards
Chetan Loke
