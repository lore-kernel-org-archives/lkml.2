Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab0IOCsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 22:48:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:33726 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab0IOCso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 22:48:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,368,1280732400"; 
   d="scan'208";a="324670401"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Shirley Ma <mashirle@us.ibm.com>
CC: Arnd Bergmann <arnd@arndb.de>, Avi Kivity <avi@redhat.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 15 Sep 2010 10:46:02 +0800
Subject: RE: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
Thread-Topic: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
Thread-Index: ActUKvFuuAEttlFbRXWBaNNr5A2hJwAUsi8A
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D792B8C815314@shsmsx502.ccr.corp.intel.com>
References: <1284410580.13351.10.camel@localhost.localdomain>
 <4C8F3C77.7010302@redhat.com>
 <1284476719.13351.35.camel@localhost.localdomain>
 <201009141721.13202.arnd@arndb.de> <20100914152231.GA13105@redhat.com>
 <1284480025.13351.49.camel@localhost.localdomain>
 <20100914162952.GB13560@redhat.com>
In-Reply-To: <20100914162952.GB13560@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Michael S. Tsirkin [mailto:mst@redhat.com]
>Sent: Wednesday, September 15, 2010 12:30 AM
>To: Shirley Ma
>Cc: Arnd Bergmann; Avi Kivity; Xin, Xiaohui; David Miller; netdev@vger.kernel.org;
>kvm@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: Re: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host kernel
>
>On Tue, Sep 14, 2010 at 09:00:25AM -0700, Shirley Ma wrote:
>> On Tue, 2010-09-14 at 17:22 +0200, Michael S. Tsirkin wrote:
>> > I would expect this to hurt performance significantly.
>> > We could do this for asynchronous requests only to avoid the
>> > slowdown.
>>
>> Is kiocb in sendmsg helpful here? It is not used now.
>>
>> Shirley
>
>Precisely. This is what the patch from Xin Xiaohui does.  That code
>already seems to do most of what you are trying to do, right?
>
>The main thing missing seems to be macvtap integration, so that we can fall back
>on data copy if zero copy is unavailable?
>How hard would it be to basically link the mp and macvtap modules
>together to get us this functionality? Anyone?
>
Michael,
Is to support macvtap with zero-copy through mp device the functionality
you mentioned above?
Before Shirley Ma has suggested to move the zero-copy functionality into
tun/tap device or macvtap device. How do you think about that? I suspect
there will be a lot of duplicate code in that three drivers except we can extract
code of zero-copy into kernel APIs and vhost APIs.
Do you think that's worth to do and help current process which is blocked too
long than I expected?

>
>--
>MST
