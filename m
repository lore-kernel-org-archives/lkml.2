Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab0KJJ6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 04:58:53 -0500
Received: from exprod5og103.obsmtp.com ([64.18.0.145]:46732 "HELO
	exprod5og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755280Ab0KJJ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 04:58:50 -0500
Message-ID: <4CDA6CD4.3010308@panasas.com>
Date: Wed, 10 Nov 2010 11:58:44 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Vladislav Bolkhovitin <vst@vlnb.net>
CC: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>,
        Bart Van Assche <bart.vanassche@gmail.com>,
        James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>,
        Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
References: <20101011213235.GA11489@kroah.com> <4CB4AEB9.30501@vlnb.net> <20101012190345.GA25737@kroah.com> <4CB75E81.7000208@vlnb.net> <20101014200413.GA30831@kroah.com> <4CC1CA4D.1090609@vlnb.net> <20101022175624.GA13640@kroah.com> <4CC1DAA2.7030602@vlnb.net> <20101022185437.GA9103@kroah.com> <4CD8566D.1020202@vlnb.net> <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net>
In-Reply-To: <4CD9A9B8.70708@vlnb.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2010 09:58:48.0971 (UTC) FILETIME=[DF0FA5B0:01CB80BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 10:06 PM, Vladislav Bolkhovitin wrote:
> 
> Sorry, but what is incorrect in the working implementation without any
> bugs doing its job in the simplest, smallest and clearest way?
> 
> If those objects remade to free themselves in the kobjects release(),
> what value would it add to them? Would the implementation be simpler,
> smaller or clearer? Not, I believe, new implementation would be only
> bigger and less clear. So, what's the point to do it to make the code worse?
> 

Totally theoretically speaking, since I have not inspected the code.

If today you wait for the count to reach zero, then unregister
and send an event to some other subsystem to free the object.

Is it not the same as if you take an extra refcount, unregister and
send the event at count=1. Then at that other place decrement the last
count to cause the object to be freed.

I agree that it is hard to do lockless. what some places do is have
an extra kref. The kobj has a single ref on it. everything takes the
other kref. when that reaches zero the unregister and event fires
and at free you decrement the only kobj ref to deallocate. This is one
way. In some situations you can manage with a single counter it all
depends.

Boaz
