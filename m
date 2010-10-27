Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284Ab0J0NoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:44:19 -0400
Received: from smtp.nokia.com ([192.100.122.233]:52778 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab0J0NoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:44:16 -0400
From: <samu.p.onkalo@nokia.com>
To: <alan@linux.intel.com>
CC: <gregkh@suse.de>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Date: Wed, 27 Oct 2010 15:43:49 +0200
Subject: RE: sysfs and power management
Thread-Topic: sysfs and power management
Thread-Index: Act11K3W2zsT92B6RtSSu6MlqaWdSQAB5J/g
Message-ID: <62697B07E9803846BC582181BD6FB6B836EB2994F4@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1288177143.12206.22.camel@4fid08082>
 <20101027124816.7087436a@linux.intel.com>
In-Reply-To: <20101027124816.7087436a@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 27 Oct 2010 13:43:52.0937 (UTC) FILETIME=[FE44D590:01CB75DC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: ext Alan Cox [mailto:alan@linux.intel.com]
>
>> I started to wonder if it makes sense to enhance sysfs so that it
>> optionally prodives open / close call backs. Internally sysfs has
>> some bookkeeping about the refcount but this is not visible to the
>> driver. Of course majority of the sysfs users doesn't need that at all
>> and for them this is just overhead.
>
>I think we need it. There doesn't need to be much overhead however as
>there is no need (or sense) in providing per sysfs node open/close
>hooks.

Do you mean per device hook and each sysfs open / close uses 
per device ref-counting.

So the driver would just know that some sysfs  entry is open 
or all the entries are closed. I think that this kind of behavior
is ok for this purpose.

>
>The pm layer also lacks a clean race-free way to actually ascertain
>when the device was last kicked out of pm saving.
