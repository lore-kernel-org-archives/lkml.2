Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab0G2UYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 16:24:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab0G2UYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 16:24:19 -0400
Message-ID: <4C51E36F.6060906@redhat.com>
Date: Thu, 29 Jul 2010 22:24:15 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100713 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, util-linux-ng@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] loop: add some basic read-only sysfs attributes
References: <20100722101541.GU15652@nb.net.home> <1280410435-7017-1-git-send-email-mbroz@redhat.com> <AANLkTikKAPToXUSecEThgXfufM73huircg2YB-UiG_ZY@mail.gmail.com> <4C518AC9.4040208@redhat.com> <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com> <20100729145827.GB1981@nb.net.home> <AANLkTinq4TUobEwnfpMFAkCugTokSZ-8KQ-ryuv6jXCc@mail.gmail.com> <20100729195616.GF1981@nb.net.home>
In-Reply-To: <20100729195616.GF1981@nb.net.home>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2010 09:56 PM, Karel Zak wrote:
>> Sure it does. Sysfs attributes need to be created _before_ uevents are
>> sent out. The current behavior is that all blockdev attributes are
>> safely created before the event is sent. These loop attributes are
>> created _after_ the event is sent.
>>
>> The question is if we can rely on the fact, that 'add' events never
>> want to look at any of these attributes, and all can be deferred to

The problem is that add_disk() initializes kobject and announces device.
How can I add some new attributes (subdir) with the current code
before it happens?

And why it is problem at all? After configuration there is always change
event and at this time attributes are there.

Milan
