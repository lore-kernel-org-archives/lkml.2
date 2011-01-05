Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab1AENfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 08:35:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab1AENfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 08:35:13 -0500
Message-ID: <4D247388.9060302@redhat.com>
Date: Wed, 05 Jan 2011 14:35:04 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kref: add kref_test_and_get
References: <4D025154.8030400@redhat.com> <20101210165553.GE31737@redhat.com> <4D07D2AC.6000500@fusionio.com> <4D0B68AF.80804@redhat.com> <4D0BB4A1.8080305@fusionio.com> <4D13664C.3020500@redhat.com> <20101223153915.GE9502@redhat.com> <4D13810B.8000304@redhat.com> <20101224192916.GB2082@redhat.com> <4D23423A.60707@redhat.com> <20110104205720.GA4180@kroah.com>
In-Reply-To: <20110104205720.GA4180@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 09:57 PM, Greg KH wrote:
> On Tue, Jan 04, 2011 at 04:52:26PM +0100, Jerome Marchand wrote:
>>
>> Add kref_test_and_get() function, which atomically add a reference only if
>> refcount is not zero. This prevent to add a reference to an object that is
>> already being removed.
> 
> We just removed a function like this recently as it really isn't the
> solution for what you need here at all.

What function are you talking about? kref_set? If yes, I don't see the
similarity between this function and mine.

Regards
Jerome

> 
> Please use a lock that protects the desctruction of the kref, like the
> rest of the kernel, to keep someone from grabing a reference while the
> device could be going away.  That's the only way to safely do this.
> 
> See the archives for why this overall, isn't a good idea for a kref to
> have this type of function.
> 
> thanks,
> 
> greg k-h

