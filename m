Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1HQSlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 14:41:01 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44112 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab1HQSk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 14:40:58 -0400
References: <20110727095557.GL3824@shale.localdomain> <9C2475AA-829E-4BB8-A3D2-2444803A33D3@gmail.com> <4E33C3F5.9000602@bfs.de> <20110730085131.GE5575@shale.localdomain>
In-Reply-To: <20110730085131.GE5575@shale.localdomain>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <56274C82-8FCA-45F9-B3DC-9863889694AA@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: walter harms <wharms@bfs.de>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: Re: [patch] w1: off by one in w1_f29_remove_slave()
Date: Wed, 17 Aug 2011 14:42:56 -0400
To: Dan Carpenter <error27@gmail.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 30, 2011, at 4:51, Dan Carpenter wrote:

> On Sat, Jul 30, 2011 at 10:42:29AM +0200, walter harms wrote:
>> Is there any reason to release the data "backwards" ?
>> The default way is to go upwards. that looks more readable.
> 
> I considered doing it that way.  It would work.  I throught maybe
> they were going to add something where it needed to be unwound LIFO
> order.
> 
> I'll wait for Jean-Françoisto say which way is prefered.
> 
Sorry for the delay. Sorry also for the trouble this dummy copy/paste mistake is causing. It's a bit embarrassing even if the intentions are good ;) This second mistake explains why I wasn't getting ill effects from the remove.

The sysfs files were removed backwards as a programmer reflex. In this case it is not really necessary since there are no real dependencies between the function implementations... but there may be in the future. This is why it's a safe habit to do it this way.

I would keep the removal in reverse order,  so I will ack the the v2 patch

Cheers!
/jfd
> regards,
> dan carpenter

