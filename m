Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab2DBRKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:10:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60135 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2DBRKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:10:33 -0400
MIME-Version: 1.0
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9C01454D13A6@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com>
 <20120305215602.GA1693@redhat.com> <4F5798B1.5070005@jp.fujitsu.com>
 <65795E11DBF1E645A09CEC7EAEE94B9CB951A45F@USINDEVS02.corp.hds.com> <65795E11DBF1E645A09CEC7EAEE94B9C01454D13A6@USINDEVS02.corp.hds.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Mon, 2 Apr 2012 10:10:12 -0700
X-Google-Sender-Auth: 8RWpR34mnt5nbdT_3PxaUEtsfLw
Message-ID: <CAHGf_=p9OgVC9J-Nh78CTbuMbc9CVt-+-G+CNbYUsgz70Uc8Qg@mail.gmail.com>
Subject: Re: [RFC][PATCH] avoid swapping out with swappiness==0
To: Satoru Moriya <satoru.moriya@hds.com>
Cc: "jweiner@redhat.com" <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/30 Satoru Moriya <satoru.moriya@hds.com>:
> Hello Kosaki-san,
>
> On 03/07/2012 01:18 PM, Satoru Moriya wrote:
>> On 03/07/2012 12:19 PM, KOSAKI Motohiro wrote:
>>> Thank you. I brought back to memory it. Unfortunately DB folks are
>>> still mainly using RHEL5 generation distros. At that time,
>>> swapiness=0 doesn't mean disabling swap.
>>>
>>> They want, "don't swap as far as kernel has any file cache page". but
>>> linux don't have such feature. then they used swappiness for emulate
>>> it. So, I think this patch clearly make userland harm. Because of, we
>>> don't have an alternative way.
>
> As I wrote in the previous mail(see below), with this patch
> the kernel begins to swap out when the sum of free pages and
> filebacked pages reduces less than watermark_high.
>
> So the kernel reclaims pages like following.
>
> nr_free + nr_filebacked >= watermark_high: reclaim only filebacked pages
> nr_free + nr_filebacked <  watermark_high: reclaim only anonymous pages

How?
