Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab0EXSPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:15:19 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42079 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab0EXSPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:15:17 -0400
Date: Mon, 24 May 2010 14:03:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Satish Eerpini <eerpini@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, reinette.chatre@intel.com
Subject: Re: iwl3945 bug in 2.6.34
Message-ID: <20100524180356.GA2413@tuxdriver.com>
References: <AANLkTik_7rxDBc0TKlAfoYyM5S6Cf_Hyxbr4W5ORnTsq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik_7rxDBc0TKlAfoYyM5S6Cf_Hyxbr4W5ORnTsq@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 11:55:43AM +0530, Satish Eerpini wrote:

> I am running a custom compiled 2.6.34 (fedora 12) on a hp nx7400 with
> a Intel Pro Wireless 3945 card, the card works fine and connects to a
> WEP secure wireless connection on my router. But after some time
> network manager starts reporting that the wireless access point is not
> available anymore and tries to reconnect to the network, though the
> network is still available, it fails to detect the network , I have
> not been able to reproduce the situation conclusively, seems to be
> happening randomly ... here is the tail from "dmesg" which looked
> suspicious :
> (btw, I also faced the same problem earlier when I was running RHEL
> beta 6.0 on the same machine)

Are you only experiencing this issue w/ a 2.6.34 kernel?  Or also
with Fedora-provided kernels?  If the latter, please be sure to open
a bug at bugzilla.redhat.com and Cc: linville@redhat.com when you do.


> No probe response from AP 00:1b:da:2a:a1:53 after 500ms, disconnecting.
> iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
> iwl3945 0000:10:00.0: Error setting new configuration (-110).
> iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
> iwl3945 0000:10:00.0: Error setting new configuration (-110).

<snip>

This looks like the firmware died.  Since this is iwl3945, you might
try a patch like Reinette suggests here:

https://bugzilla.redhat.com/show_bug.cgi?id=589777#c5

Does that enable the device to recover?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
